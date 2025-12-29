#!/bin/bash

# 备份原始文件
cp cw.xml cw.xml.bak

# 1. 在compiler标签后添加default块
sed -i '/<compiler angle="radian" meshdir="..\/meshes\/" \/>/a \    <default>\n        <joint limited="true" damping="0.001" armature="0.01" frictionloss="0.1"/>\n        <motor ctrllimited="true"/>\n        <geom condim="4" contype="1" conaffinity="15" solref="0.001 2" friction="0.9 0.2 0.2"/>\n        <equality solref="0.001 2"/>\n    </default>' cw.xml

# 2. 修改base_link的z坐标为0.7
sed -i 's/<body name="base_link" pos="0 0 0"/<body name="base_link" pos="0 0 0.7"/' cw.xml

# 3. 修改floating_base_joint添加limited="false"
sed -i 's/<joint name="floating_base_joint" type="free" \/>/<joint name="floating_base_joint" type="free" limited="false" \/>/' cw.xml

# 4. 在floating_base_joint后添加imu site
sed -i '/<joint name="floating_base_joint" type="free" limited="false" \/>/a \        <site name="imu" size="0.01" pos="0.0 0 0.0" quat="1 0 0 0"/>' cw.xml

# 5. 在</worldbody>后添加actuator和sensor块
sed -i '/<\/worldbody>/a \    <actuator>\n        <motor name="l_hip_roll" joint="l_hip_roll_joint" gear="1" ctrllimited="true" ctrlrange="-12 12"/>\n        <motor name="l_hip_yaw" joint="l_hip_yaw_joint" gear="1" ctrllimited="true" ctrlrange="-12 12"/>\n        <motor name="l_hip_pitch" joint="l_hip_pitch_joint" gear="1" ctrllimited="true" ctrlrange="-12 12"/>\n        <motor name="l_knee_pitch" joint="l_knee_pitch_joint" gear="1" ctrllimited="true" ctrlrange="-12 12"/>\n        <motor name="l_ankle_pitch" joint="l_ankle_pitch_joint" gear="1" ctrllimited="true" ctrlrange="-12 12"/>\n        <motor name="r_hip_roll" joint="r_hip_roll_joint" gear="1" ctrllimited="true" ctrlrange="-12 12"/>\n        <motor name="r_hip_yaw" joint="r_hip_yaw_joint" gear="1" ctrllimited="true" ctrlrange="-12 12"/>\n        <motor name="r_hip_pitch" joint="r_hip_pitch_joint" gear="1" ctrllimited="true" ctrlrange="-12 12"/>\n        <motor name="r_knee_pitch" joint="r_knee_pitch_joint" gear="1" ctrllimited="true" ctrlrange="-12 12"/>\n        <motor name="r_ankle_pitch" joint="r_ankle_pitch_joint" gear="1" ctrllimited="true" ctrlrange="-12 12"/>\n    <\/actuator>\n    <sensor>\n        <framequat name="orientation" objtype="site" noise="0.001" objname="imu"/>\n        <framepos name="position" objtype="site" noise="0.001" objname="imu"/>\n        <gyro name="angular-velocity" site="imu" noise="0.005" cutoff="34.9"/>\n        <velocimeter name="linear-velocity" site="imu" noise="0.001" cutoff="30"/>\n        <accelerometer name="linear-acceleration" site="imu" noise="0.005" cutoff="157"/>\n        <magnetometer name="magnetometer" site="imu"/>\n    <\/sensor>' cw.xml

echo "修改完成，原始文件已备份为cw.xml.bak"
