% Sashankh Chengavalli Kumar - A0162363J
close all

% Q1
disp('Question 1')
pts = zeros(8, 3);
pts(1, :) = [-1 -1 -1];
pts(2, :) = [1 -1 -1];
pts(3, :) = [1 1 -1];
pts(4, :) = [-1 1 -1];
pts(5, :) = [-1 -1 1];
pts(6, :) = [1 -1 1];
pts(7, :) = [1 1 1];
pts(8, :) = [-1 1 1];
disp(pts)

% Q2
disp('Question 2')

% Camera positions ( first row rep init pos )
cam_pos = zeros(4, 3);
cam_pos(1, :) = [0 0 -5];

disp(['Camera position ', num2str(1)]);
disp(cam_pos(1, :));

% Rotation quaternion from Lecture 9 Slide 18
ra = deg2rad(-30)/2;  % Rotation angle
q = [(cos(ra)) (sin(ra) * 0) (sin(ra) * 1) (sin(ra) * 0)];

% Rotation matrix from Lecture 9 Slide 21
rot_mat = get_rot_matrix(q);

% Calculate positions by quaternion multiplication
for i = 2 : 4
    disp(['Camera position ', num2str(i)]);
    cam_pos(i, :) = rot_mat * cam_pos(i-1, :)';
    disp(cam_pos(i, :));
end

% Q3
% Using roll pitch yaw
disp('Question 3');
euler_rot_mat = get_euler_rot_mat(0, deg2rad(30), 0);

rpymat_1 = [1 0 0; 0 1 0; 0 0 1];
rpymat_2 = euler_rot_mat * rpymat_1;
rpymat_3 = euler_rot_mat * rpymat_2;
rpymat_4 = euler_rot_mat * rpymat_3;

disp('using roll, pitch and yaw representation for rotation, the computed matrices are : ');
rpymat_1
rpymat_2
rpymat_3
rpymat_4


% Using quaternion
ra = deg2rad(30)/2;  % Rotation angle
q = [(cos(ra)) (sin(ra) * 0) (sin(ra) * 1) (sin(ra) * 0)];
quat_rot_mat = get_rot_matrix(q);

quatmat_1 = [1 0 0; 0 1 0; 0 0 1];
quatmat_2 = quatmat_1 * quat_rot_mat;
quatmat_3 = quatmat_2 * quat_rot_mat;
quatmat_4 = quatmat_3 * quat_rot_mat;

disp('using quaternion representation for rotation, the computed matrices are : ');
quatmat_1
quatmat_2
quatmat_3
quatmat_4

% Verification

disp('Verifying rpymat_1 = quatmat_1');
diff = rpymat_1 - quatmat_1;
disp('rpymat_1 - quatmat_1 = ');
disp(diff)

disp('Verifying rpymat_2 = quatmat_2');
diff = rpymat_2 - quatmat_2;
disp('rpymat_2 - quatmat_2 = ');
disp(diff)

disp('Verifying rpymat_3 = quatmat_3');
diff = rpymat_3 - quatmat_3;
disp('rpymat_3 - quatmat_3 = ');
disp(diff)

disp('Verifying rpymat_4 = quatmat_4');
diff = rpymat_4 - quatmat_4;
disp('rpymat_4 - quatmat_4 = ');
disp(diff)

% Q4
% Orthographic projection

U = zeros(nframes, npts); % array holding the image coordinates (horizontal)
V = zeros(nframes, npts); % array holding the image coordinates (vertical)

% For each position
for position_num = 1 : nframes
    % For each point
    for point_num = 1 : npts
        % Get a point
        point = pts(point_num, :);
        
        % Get the camera position
        cp = cam_pos(position_num, :);
        
        % Camera axes at that position
        axes = quatmats(:, :, position_num);
        xa = axes(1, :);
        ya = axes(2, :);
        za = axes(3, :);
        
        % Position of point rel to camera pos ( Sp - Tf )
        rel_pos = point - cp;
        
        % Applying perspective projection equation from Lecture 8 Slide 11
        U(position_num, point_num) = rel_pos * xa';
        V(position_num, point_num) = rel_pos * ya';
    end
end

% Plot the projection
figure
for fr = 1 : nframes
    subplot(2,2,fr), plot(U(fr,:), V(fr,:), '*');
    for p = 1 : npts
        text(U(fr,p)+0.02, V(fr,p)+0.02, num2str(p));
    end
end

% Perspective projection

nframes = 4; % number of frames
npts = size(pts,1); % number of 3D points
U = zeros(nframes, npts); % array holding the image coordinates (horizontal)
V = zeros(nframes, npts); % array holding the image coordinates (vertical)

% Push quatmat_i into a 3D array so we can access in for loop
quatmats(:, :, 1) = quatmat_1;
quatmats(:, :, 2) = quatmat_2;
quatmats(:, :, 3) = quatmat_3;
quatmats(:, :, 4) = quatmat_4;
 
% For each position
for position_num = 1 : nframes
    % For each point
    for point_num = 1 : npts
        % Get a point
        point = pts(point_num, :);
        
        % Get the camera position
        cp = cam_pos(position_num, :);
        
        % Camera axes at that position
        axes = quatmats(:, :, position_num);
        xa = axes(1, :);
        ya = axes(2, :);
        za = axes(3, :);
        
        % Position of point rel to camera pos ( Sp - Tf )
        rel_pos = point - cp;
        
        % Applying perspective projection equation from Lecture 8 Slide 11
        U(position_num, point_num) = (1 * rel_pos * xa') / (rel_pos * za');
        V(position_num, point_num) = (1 * rel_pos * ya') / (rel_pos * za');
    end
end

% Plot the projection
figure
for fr = 1 : nframes
    subplot(2,2,fr), plot(U(fr,:), V(fr,:), '*');
    for p = 1 : npts
        text(U(fr,p)+0.02, V(fr,p)+0.02, num2str(p));
    end
end 

% Q5
% Solving for homography matrix as given in Lecture 9 Slide 39
% We pick camera position 3 and first four points

h = zeros(8, 9);

h(1, :) = [pts(1, 1) pts(1, 2) pts(1, 3) 0 0 0 -pts(1,1)*U(3, 1) -pts(1,2)*U(3, 1) -U(3, 1)*pts(1, 3)];
h(2, :) = [0 0 0 pts(1, 1) pts(1, 2) pts(1, 3) -pts(1,1)*V(3, 1) -pts(1,2)*V(3, 1) -V(3, 1)*pts(1, 3)];
h(3, :) = [pts(2, 1) pts(2, 2) pts(2, 3) 0 0 0 -pts(2,1)*U(3, 2) -pts(2,2)*U(3, 2) -U(3, 2)*pts(2, 3)];
h(4, :) = [0 0 0 pts(2, 1) pts(2, 2) pts(2, 3) -pts(2,1)*V(3, 2) -pts(2,2)*V(3, 2) -V(3, 2)*pts(2, 3)];
h(5, :) = [pts(3, 1) pts(3, 2) pts(3, 3) 0 0 0 -pts(3,1)*U(3, 3) -pts(3,2)*U(3, 3) -U(3, 3)*pts(3, 3)];
h(6, :) = [0 0 0 pts(3, 1) pts(3, 2) pts(3, 3) -pts(3,1)*V(3, 3) -pts(3,2)*V(3, 3) -V(3, 3)*pts(3, 3)];
h(7, :) = [pts(4, 1) pts(4, 2) pts(4, 3) 0 0 0 -pts(4,1)*U(3, 4) -pts(4,2)*U(3, 4) -U(3, 4)*pts(4, 3)];
h(8, :) = [0 0 0 pts(4, 1) pts(4, 2) pts(4, 3) -pts(4,1)*V(3, 4) -pts(4,2)*V(3, 4) -V(3, 4)*pts(4, 3)];

% Lecture 2 Slide 36 shows this method of solving the equation
[U S V] = svd(h);
% S

% From S we observe that there is one singular value that is zero ( last one ) 
% Lecture 2 Slide 36 explains why solution will be found as linear
% combination of the last column, in this case (non-zero singular value)  
% Alternatively, using the last column will give us the closest solution.

diary on
sol = reshape(V(:, 9), 3, 3)';
disp(sol);

disp('Normalizing wrt 3,3');
sol = sol / sol(3, 3);
disp(sol);
diary off
% Acknowledgement: Thanks to Aadyaa Maddi with whom I discussed some parts
% of this lab

function r = get_rot_matrix(q)
    r = [q(1)*q(1)+q(2)*q(2)-q(3)*q(3)-q(4)*q(4) 2*(q(2)*q(3)-q(1)*q(4)) 2*(q(2)*q(4)+q(1)*q(3)); 
         2*(q(2)*q(3)+q(1)*q(4)) q(1)*q(1)+q(3)*q(3)-q(2)*q(2)-q(4)*q(4) 2*(q(3)*q(4)+q(1)*q(2));
         2*(q(2)*q(4)-q(1)*q(3)) 2*(q(3)*q(4)+q(1)*q(2)) q(1)*q(1)+q(4)*q(4)-q(2)*q(2)-q(3)*q(3)];
end

function r = get_euler_rot_mat(w, phi, k)
    r = [(cos(k)*cos(phi)) (cos(k)*sin(phi)*sin(w)-sin(k)*cos(w)) (cos(k)*sin(phi)*cos(w)+sin(k)*sin(w));
        (sin(k)*cos(phi)) (sin(k)*sin(phi)*sin(w)+cos(k)*cos(w)) (sin(k)*sin(phi)*cos(w)-cos(k)*sin(w));
        (-sin(phi)) (cos(phi)* sin(w)) cos(phi)*cos(w)];
end

% Unused code - tried to do quaternion multiplication earlier.
function c = cnj(q)
    c = zeros(1, 4);
    c(1) = q(1);
    c(2) = -q(2);
    c(3) = -q(3);
    c(4) = -q(4);
end

function product = quaternion_product(p, q)
    product = zeros(1, 4);
    product(1) = p(1) * q(1) - p(2) * q(2) - p(3) * q(3) - p(4) * q(4);
    product(2) = p(1) * q(2) + p(2) * q(1) + p(3) * q(4) - p(4) * q(3);
    product(3) = p(1) * q(3) - p(2) * q(4) + p(3) * q(1) + p(4) * q(2);
    product(4) = p(1) * q(4) + p(2) * q(3) - p(3) * q(2) + p(4) * q(1);
end