function [] = CIS_save_slicerTF(TFmat, fixed, name)
%CIS_SAVE_SLICERTF saves transform for a slicer. var name must be in
%string
%   Detailed explanation goes here

TF = reshape(TFmat(1:3,:),12,1);

output = fopen([name,'.txt'], 'wt');
fprintf(output, '%s\n','#Insight Transform File V1.0');
fprintf(output, '%s\n','#Transform 0');
fprintf(output, '%s\n','Transform: AffineTransform_double_3_3');
fprintf(output, '%s %.14f %.14f %.14f %.14f %.14f %.14f %.14f %.14f %.14f %.14f %.14f %.14f','Parameters:',TF(1),TF(2),TF(3),TF(4),TF(5),TF(6),TF(7),TF(8),TF(9),TF(10),TF(11),TF(12));
fprintf(output, '\n%s %i %i %i','FixedParameters:',fixed(1),fixed(2),fixed(3));
fprintf(output, '\n');
fclose(output);

end

