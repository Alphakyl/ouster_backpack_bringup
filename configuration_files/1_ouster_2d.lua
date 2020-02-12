-- Copyright 2016 The Cartographer Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "map",
  tracking_frame = "imu_viz_link",
  published_frame = "imu_viz_link",
  odom_frame = "odom",
  provide_odom_frame = false,
  publish_frame_projected_to_2d = true,
  use_odometry = false,
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 0,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 1,
  lookup_transform_timeout_sec = 0.2,
  submap_publish_period_sec = 0.05,
  pose_publish_period_sec = 5e-3,
  trajectory_publish_period_sec = 30e-3,
  rangefinder_sampling_ratio = 1.,
  odometry_sampling_ratio = 1.,
  fixed_frame_pose_sampling_ratio = 1.,
  imu_sampling_ratio = 1.,
  landmarks_sampling_ratio = 1.,
}

---------------------
-- DEFAULT CHANGES --
---------------------

POSE_GRAPH.optimization_problem.ceres_solver_options.max_num_iterations = 10
POSE_GRAPH.constraint_builder.min_score = 0.62
POSE_GRAPH.constraint_builder.global_localization_min_score = 0.66

-------------------------------
-- CUSTOM MAP_BUILER CHANGES --
-------------------------------

MAP_BUILDER.use_trajectory_builder_2d = true

MAP_BUILDER.num_background_threads = 6
-- MAP_BUILDER.num_background_threads = 7

------------------------------------------
-- CUSTOM TRAJECTORY_BUILDER_3D CHANGES --
------------------------------------------

TRAJECTORY_BUILDER_2D.use_imu_data = true
-- TRAJECTORY_BUILDER_2D.use_imu_data = true
-- Only an option for 2d

TRAJECTORY_BUILDER_2D.min_range = 0.5
-- TRAJECTORY_BUILDER_2D.min_range = 0.

TRAJECTORY_BUILDER_2D.max_range = 100.
-- TRAJECTORY_BUILDER_2D.max_range = 30.

TRAJECTORY_BUILDER_2D.min_z = -0.05
-- TRAJECTORY_BUILDER_2D.min_z = -0.8

TRAJECTORY_BUILDER_2D.max_z = 0.70
-- TRAJECTORY_BUILDER_2D.max_z = 2.

TRAJECTORY_BUILDER_2D.missing_data_ray_length = 5.0
-- TRAJECTORY_BUILDER_2D.missing_data_ray_length = 5.0

TRAJECTORY_BUILDER_2D.num_accumulated_range_data = 1
-- Set to 1 because only need one Ouster point cloud message / full 360 coverage

TRAJECTORY_BUILDER_2D.ceres_scan_matcher.translation_weight = 1.
-- TRAJECTORY_BUILDER_2D.ceres_scan_matcher.translation_weight = 10.

TRAJECTORY_BUILDER_2D.ceres_scan_matcher.rotation_weight = 10.
-- TRAJECTORY_BUILDER_2D.ceres_scan_matcher.rotation_weight = 40.

TRAJECTORY_BUILDER_2D.ceres_scan_matcher.ceres_solver_options.num_threads = 6
-- TRAJECTORY_BUILDER_2D.ceres_scan_matcher.ceres_solver_options.num_threads = 1

TRAJECTORY_BUILDER_2D.motion_filter.max_time_seconds = 0.5
-- TRAJECTORY_BUILDER_2D.motion_filter.max_time_seconds = 5.

TRAJECTORY_BUILDER_2D.motion_filter.max_distance_meters = 0.1
-- TRAJECTORY_BUILDER_2D.motion_filter.max_distance_meters = 0.2

TRAJECTORY_BUILDER_2D.motion_filter.max_angle_radians = 0.004
-- TRAJECTORY_BUILDER_2D.motion_filter.max_angle_radians = math.rad(1.)

-------------------------------
-- CUSTOM POSE_GRAPH CHANGES --
-------------------------------

POSE_GRAPH.optimization_problem.huber_scale = 5e2
-- POSE_GRAPH.optimization_problem.huber_scale = 5e2

POSE_GRAPH.optimize_every_n_nodes = 320
-- POSE_GRAPH.optimize_every_n_nodes = 90
-- Set to 320 for loop closure, set to 0 for no loop closure

POSE_GRAPH.constraint_builder.sampling_ratio = 0.03
-- POSE_GRAPH.constraint_builder.sampling_ratio = 0.3

POSE_GRAPH.constraint_builder. max_constraint_distance = 30.
-- POSE_GRAPH.constraint_builder. max_constraint_distance = 15.

POSE_GRAPH.constraint_builder.ceres_scan_matcher.ceres_solver_options.num_threads = 6
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher.num_threads = 1

POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_xy_search_window = 10.
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_xy_search_window = 5.

POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_z_search_window = 5.
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_z_search_window = 1.

POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.angular_search_window = math.rad(22.5)
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.angular_search_window = math.rad(15.)
-- IMPACT: MORE DRIFT-TOLERANT LOOP CLOSURES (NEED TO TRY REDUCING FOR 360 FOV CASE)

POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.rotation_weight = 100.
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.rotation_weight = 1.
-- IMPACT: WEIGHTS ROTATION MORE (NEED TO TRY REDUCING FOR 360 FOV CASE)

POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.ceres_solver_options.num_threads = 6
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.ceres_solver_options.num_threads = 1
-- IMPACT: HAS NOT BEEN EVALUATED, NEED TO TEST EFFECT ON LATENCY

POSE_GRAPH.optimization_problem.log_solver_summary = true
-- POSE_GRAPH.optimization_problem.log_solver_summary = false
-- SET TO TRUE SO PRINTS IMU TRANSFORM ERROR WHEN LOOP CLOSURE OCCURS

POSE_GRAPH.optimization_problem.use_online_imu_extrinsics_in_3d = true
-- POSE_GRAPH.optimization_problem.use_online_imu_extrinsics_in_3d = true

POSE_GRAPH.optimization_problem.fix_z_in_3d = false
-- POSE_GRAPH.optimization_problem.fix_z_in_3d = false

POSE_GRAPH.optimization_problem.ceres_solver_options.num_threads = 6
-- POSE_GRAPH.optimization_problem.ceres_solver_options.num_threads = 7

POSE_GRAPH.global_sampling_ratio = 0.1
-- POSE_GRAPH.global_sampling_ratio = 0.003

return options
