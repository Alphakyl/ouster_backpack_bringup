#!/bin/bash
rosbag record -o ./bag/test1 \
/HD2/Altitude \
/HD2/Pressure \
/HD2/Temperature \
/HD2/imu_raw \
/HD2/os1_cloud_node_h/points \
/HD2/os1_cloud_node_v/points \
/HD2/trajectory_node_list \
/rosout \
/rosout_agg \
/tf \
/tf_static

