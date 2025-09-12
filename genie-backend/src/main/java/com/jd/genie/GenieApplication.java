package com.jd.genie;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@SpringBootApplication
public class GenieApplication {
    public static void main(String[] args) throws UnknownHostException {
        SpringApplication app = new SpringApplication(GenieApplication.class);
        Map<String, Object> defaultProperties = new HashMap<>();
        
        // 动态判断运行环境并设置profile
        String profile = determineActiveProfile();
        defaultProperties.put("spring.profiles.active", profile);
        
        app.setDefaultProperties(defaultProperties);
        log.info("[GENIE] Active Profile: {}", profile);
        
        app.run(args);
    }
    
    /**
     * 动态判断运行环境
     * @return profile名称
     */
    private static String determineActiveProfile() {
        // 1. 优先检查系统属性和环境变量
        String profile = System.getProperty("spring.profiles.active");
        if (profile != null && !profile.isEmpty()) {
            log.info("[GENIE] Profile from system property: {}", profile);
            return profile;
        }
        
        profile = System.getenv("SPRING_PROFILES_ACTIVE");
        if (profile != null && !profile.isEmpty()) {
            log.info("[GENIE] Profile from environment variable: {}", profile);
            return profile;
        }
        
        // 2. 判断是否在Docker容器中运行
        if (isRunningInDocker()) {
            log.info("[GENIE] Detected Docker environment, using 'docker' profile");
            return "docker";
        }
        
        // 3. 默认使用开发环境（不设置profile，使用application.yml）
        log.info("[GENIE] Using default profile for local development");
        return ""; // 空字符串表示不设置特定profile，使用默认的application.yml
    }
    
    /**
     * 跨平台判断是否在Docker容器中运行
     * @return true表示在Docker中运行
     */
    private static boolean isRunningInDocker() {
        String osName = System.getProperty("os.name").toLowerCase();
        boolean isWindows = osName.contains("windows");
        
        try {
            if (isWindows) {
                return isDockerOnWindows();
            } else {
                return isDockerOnLinux();
            }
        } catch (Exception e) {
            log.warn("[GENIE] Error detecting Docker environment: {}", e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Windows系统下的Docker检测
     */
    private static boolean isDockerOnWindows() {
        // 检查环境变量
        if ("docker".equals(System.getenv("container")) || 
            System.getenv("DOCKER_CONTAINER") != null ||
            System.getenv("DOCKERIZED") != null) {
            return true;
        }
        
        // 检查主机名格式(Docker容器通常有12位随机主机名)
        try {
            String hostname = InetAddress.getLocalHost().getHostName();
            if (hostname != null && hostname.length() == 12 && hostname.matches("[0-9a-f]+")) {
                return true;
            }
        } catch (UnknownHostException e) {
            // 忽略主机名检查错误
        }
        
        return false;
    }
    
    /**
     * Linux/Unix系统下的Docker检测
     */
    private static boolean isDockerOnLinux() {
        // 方法1: 检查/.dockerenv文件
        if (new java.io.File("/.dockerenv").exists()) {
            return true;
        }
        
        // 方法2: 检查/proc/1/cgroup文件
        java.nio.file.Path cgroupPath = java.nio.file.Paths.get("/proc/1/cgroup");
        if (java.nio.file.Files.exists(cgroupPath)) {
            try {
                String content = java.nio.file.Files.readString(cgroupPath, java.nio.charset.StandardCharsets.UTF_8);
                if (content.contains("docker") || content.contains("/docker/")) {
                    return true;
                }
            } catch (Exception e) {
                // 忽略读取错误
            }
        }
        
        // 方法3: 检查环境变量
        if ("docker".equals(System.getenv("container")) || 
            System.getenv("DOCKER_CONTAINER") != null) {
            return true;
        }
        
        // 方法4: 检查主机名格式(Docker容器通常有12位随机主机名)
        try {
            String hostname = InetAddress.getLocalHost().getHostName();
            if (hostname != null && hostname.length() == 12 && hostname.matches("[0-9a-f]+")) {
                return true;
            }
        } catch (UnknownHostException e) {
            // 忽略主机名检查错误
        }
        
        return false;
    }
}