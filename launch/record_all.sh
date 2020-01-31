#!/bin/bash
rosbag record -o ./bag/  \
/HD2/assembled_cloud \
/HD2/constraint_list \
/HD2/hokuyo_points \
/HD2/imu_raw \
/HD2/landmark_poses_list \
/HD2/map \
/HD2/os1_cloud_node_h/points \
/HD2/os1_cloud_node_v/points \
/HD2/scan \
/HD2/scan_matched_points2 \
/HD2/submap_list \
/HD2/trajectory_node_list \
/tf \
/tf_static
