FROM registry.cn-hangzhou.aliyuncs.com/dockerhub_mirror/java:17-anolis
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#RUN mkdir -p /jeecg-boot/config/jeecg/
WORKDIR /genie-backend
EXPOSE 8081
ADD ./target/genie-backend-0.0.1-SNAPSHOT.jar ./
CMD sleep 6;java -Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/./urandom -jar genie-backend-0.0.1-SNAPSHOT.jar