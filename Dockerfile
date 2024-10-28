FROM osrf/ros:noetic-desktop-full
SHELL ["/bin/bash", "-c"]
ENV IGNITION_VERSION=fortress

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    git \
    vim \
    lsb-release \
    python3-catkin-tools \
    python3-pip \
    curl \
    python-is-python3 \
    mesa-utils \
    libpcl-dev \
    liboctomap-dev \
    ros-noetic-octomap \
    ros-noetic-octomap-msgs \
    ros-noetic-octomap-rviz-plugins \
    ros-noetic-pcl-ros \
    tmux \
    ros-noetic-teleop-twist-keyboard \
    python3-tk 

RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] \
    http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/gazebo-stable.list

RUN apt-get update && \
    apt-get install -y ignition-fortress


RUN rosdep init || true && \
    rosdep update

RUN mkdir -p /root/catkin_ws/src
COPY . /root/catkin_ws/src/
RUN cd /root/catkin_ws/src/ros_gz/ && \
    rosdep install -r --from-paths . -i -y --rosdistro noetic


RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
    source /opt/ros/noetic/setup.bash && \
    cd /root/catkin_ws && \
    catkin build roam_mapping && \
    catkin build

RUN source /root/catkin_ws/devel/setup.bash 


RUN pip3 install scikit-image 
ENV QT_X11_NO_MITSHM=1

CMD ["/bin/bash"]

