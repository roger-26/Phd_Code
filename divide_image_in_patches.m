function patch = divide_image_in_patches(I,size_grid)
%Esta función divide una imagen en patches, de una grid cuadrada
%I es la imagen original
%size_grid --> Es el size de la grid cuadrada
%en la variable position, el primer elemento es la fila, el segundo es la
%columna, para posicionar cada patch en la imagen original
 [rows, columns, numberOfColorChannels] = size(I);
    Number_divisions = size_grid;
    size_patch = [floor(rows/Number_divisions), columns/Number_divisions];
%     imshow(I)
   patch_counter=0;
    for i=1:Number_divisions
        for j=1: Number_divisions
            patch_counter =patch_counter+1;
            patch(patch_counter).position=[j,i]
%             j
            rectangle_to_crop = [(size_patch(2)*(i-1))+1, (size_patch(1)*(j-1))+1, size_patch(2)-1,size_patch(1)-1]
            patch(patch_counter).data =imcrop(I, rectangle_to_crop);
%             figure
%             imshow(patch(patch_counter).data);
        end 
    end
end