# Copyright (c) SenseTime. All Rights Reserved.

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import os
import glob
import cv2
import torch
import numpy as np
import time

from pytracking.refine_modules.refine_module import RefineModule
from pytracking.RF_utils import bbox_clip

torch.set_num_threads(1)


class DBLoader(object):
    """ Debug Data Loader """

    def __init__(self, data_dir):
        self.data_dir = data_dir
        self.gt_file = os.path.join(self.data_dir, 'groundtruth.txt')
        self.curr_idx = 0
        self.im_paths = glob.glob(os.path.join(self.data_dir, 'img/*.jpg'))
        self.im_paths.sort()
        self.init_box = self.get_init_box()

    def get_init_box(self):
        gt = np.genfromtxt(self.gt_file, delimiter=',')
        gt = list(map(int, gt[0].tolist()))
        return np.asarray(gt)

    def region(self):
        return self.init_box

    def frame(self):
        im_path = self.im_paths[self.curr_idx] if self.curr_idx < len(self.im_paths) else None
        # print('pumping {}'.format(im_path))
        self.curr_idx += 1
        return im_path, None


def get_axis_aligned_bbox(region):
    """ convert region to (cx, cy, w, h) that represent by axis aligned box
    """
    nv = region.size
    if nv == 8:
        cx = np.mean(region[0::2])
        cy = np.mean(region[1::2])
        x1 = min(region[0::2])
        x2 = max(region[0::2])
        y1 = min(region[1::2])
        y2 = max(region[1::2])
        A1 = np.linalg.norm(region[0:2] - region[2:4]) * \
             np.linalg.norm(region[2:4] - region[4:6])
        A2 = (x2 - x1) * (y2 - y1)
        s = np.sqrt(A1 / A2)
        w = s * (x2 - x1) + 1
        h = s * (y2 - y1) + 1
    else:
        x = region[0]
        y = region[1]
        w = region[2]
        h = region[3]
        cx = x + w / 2
        cy = y + h / 2
    return cx, cy, w, h


def get_dimp(img, init_box, model_path):
    """ set up DiMPsuper as the base tracker """
    from pytracking.parameter.dimp.super_dimp_demo import parameters
    from pytracking.tracker.dimp.dimp import DiMP

    params = parameters(model_path)
    params.visualization = True
    params.debug = False
    params.visdom_info = {'use_visdom': False, 'server': '127.0.0.1', 'port': 8097}
    tracker = DiMP(params)

    H, W, _ = img.shape
    cx, cy, w, h = get_axis_aligned_bbox(np.array(init_box))
    gt_bbox_ = [cx - (w - 1) / 2, cy - (h - 1) / 2, w, h]
    '''Initialize'''
    gt_bbox_np = np.array(gt_bbox_)
    gt_bbox_torch = torch.from_numpy(gt_bbox_np.astype(np.float32))
    init_info = {}
    init_info['init_bbox'] = gt_bbox_torch
    tracker.initialize(img, init_info)

    return tracker


def get_ar(img, init_box, ar_path):
    """ set up Alpha-Refine """
    selector_path = 0
    sr = 2.0;
    input_sz = int(128 * sr)  # 2.0 by default
    RF_module = RefineModule(ar_path, selector_path, search_factor=sr, input_sz=input_sz)
    RF_module.initialize(img, np.array(init_box))
    return RF_module


def demo(base_path, ar_path, data_dr, res_folder):
    debug_loader = DBLoader(data_dir=data_dir)

    handle = debug_loader
    init_box = handle.region()
    imagefile, _ = handle.frame()
    img = cv2.cvtColor(cv2.imread(imagefile), cv2.COLOR_BGR2RGB)  # Right
    H, W, _ = img.shape

    """ Step 1: set up base tracker and Alpha-Refine """
    tracker = get_dimp(img, init_box, base_path)
    RF_module = get_ar(img, init_box, ar_path)

    # OPE tracking
    prediction = []
    while True:
        imagefile, _ = handle.frame()
        if not imagefile:
            break
        img = cv2.cvtColor(cv2.imread(imagefile), cv2.COLOR_BGR2RGB)  # Right

        """ Step 2: base tracker prediction """
        # track with base tracker
        outputs = tracker.track(img)
        pred_bbox = outputs['target_bbox']

        """ Step 3: refine tracking results with Alpha-Refine """
        pred_bbox = RF_module.refine(img, np.array(pred_bbox))

        """ Step 4: update base tracker's state with refined result """
        x1, y1, w, h = pred_bbox.tolist()
        x1, y1, x2, y2 = bbox_clip(x1, y1, x1 + w, y1 + h, (H, W))
        w = x2 - x1
        h = y2 - y1
        new_pos = torch.from_numpy(np.array([y1 + h / 2, x1 + w / 2]).astype(np.float32))
        new_target_sz = torch.from_numpy(np.array([h, w]).astype(np.float32))
        new_scale = torch.sqrt(new_target_sz.prod() / tracker.base_target_sz.prod())

        tracker.pos = new_pos.clone()
        tracker.target_sz = new_target_sz
        tracker.target_scale = new_scale

        # visualization
        pred_bbox = list(map(int, pred_bbox))
        prediction.append(pred_bbox)
        # _img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        # cv2.rectangle(_img, (pred_bbox[0], pred_bbox[1]),
        #              (pred_bbox[0] + pred_bbox[2], pred_bbox[1] + pred_bbox[3]), (0, 255, 255), 3)
        # cv2.imshow('', _img)
        # key = cv2.waitKey(1)
        # if key == ord('q'):
        #    exit(0)

    res_name = data_dir.split('/')[-1]
    print(os.path.join(res_folder, res_name + '.txt'))
    np.savetxt(os.path.join(res_folder, res_name + '.txt'), np.asarray(prediction).astype(int), fmt='%i', delimiter=",")


if __name__ == '__main__':

    # path to model_file of base tracker - model can be download from:
    # https://drive.google.com/open?id=1qDptswis2FxihLRYLVRGDvx6aUoAVVLv
    base_path = '/home/r/Downloads/AlphaRefine-master/super_dimp.pth.tar'

    # path to model_file of Alpha-Refine - the model can be download from
    # https://drive.google.com/file/d/1drLqNq4r9g4ZqGtOGuuLCmHJDh20Fu1m/view
    ar_path = '/home/r/Downloads/AlphaRefine-master/SEcmnet_ep0040-c.pth.tar'

    # data_folder = '/home/r/Current_Work_Phd/set1K_deblur'
    # data_folder = '/home/r/Current_Work_Phd/set1K_images'
    data_folder = '/home/r/Current_Work_Phd/set_1385_VariacionResolucion/1_2'

    res_folder = '/home/r/Current_Work_Phd/set_1385_VariacionResolucion/results/1_2_Alpharefine'
    # res_folder = 'C:\\Users\\juanp\\Documents\\RogerHernan\\trackers\\new_trackers\\AlphaRefine\\results'

    folders = glob.glob(os.path.join(data_folder, '*'))

    # videos = glob('videos\\*')
    current_results = glob.glob(res_folder + '/*')
    clean_current = list(map(lambda x: x.split('/')[-1][:-4], current_results))
    clean_folders = list(map(lambda x: x.split('/')[-1], folders))
    toprocess_videos = [v for v, cv in zip(folders, clean_folders) if not (cv in clean_current)]

    for data_dir in toprocess_videos:
        demo(base_path, ar_path, data_dir, res_folder)
