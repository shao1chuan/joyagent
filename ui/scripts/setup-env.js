#!/usr/bin/env node

import fs from 'fs';
import path from 'path';
import os from 'os';

/**
 * 检测当前操作系统
 * @returns {string} 操作系统类型: 'windows', 'linux', 'darwin', etc.
 */
function detectOS() {
  return os.platform();
}

/**
 * 检测是否在Docker环境中运行
 * @returns {boolean} true表示在Docker中运行
 */
function isRunningInDocker() {
  const platform = detectOS();
  console.log(`[ENV-SETUP] Detected OS: ${platform}`);
  
  try {
    // Windows系统的Docker检测
    if (platform === 'win32') {
      return isDockerOnWindows();
    }
    
    // Linux/Unix系统的Docker检测
    return isDockerOnLinux();
    
  } catch (error) {
    console.warn(`[ENV-SETUP] Error detecting Docker environment: ${error.message}`);
  }

  return false;
}

/**
 * Windows系统下的Docker检测
 * @returns {boolean} true表示在Docker中运行
 */
function isDockerOnWindows() {
  // 方法1: 检查环境变量
  if (process.env.container === 'docker' || 
      process.env.DOCKER_CONTAINER || 
      process.env.DOCKERIZED) {
    console.log('[ENV-SETUP] Detected Docker environment (Windows): environment variables');
    return true;
  }

  // 方法2: 检查主机名格式(Docker容器通常有特定格式)
  const hostname = os.hostname();
  if (hostname && hostname.length === 12 && /^[0-9a-f]+$/.test(hostname)) {
    console.log(`[ENV-SETUP] Detected Docker environment (Windows): hostname pattern ${hostname}`);
    return true;
  }

  // 方法3: 检查网络接口(Docker容器通常有特定的网络接口)
  try {
    const networkInterfaces = os.networkInterfaces();
    if (networkInterfaces.eth0 && !networkInterfaces.Ethernet) {
      console.log('[ENV-SETUP] Detected Docker environment (Windows): network interfaces');
      return true;
    }
  } catch (error) {
    // 忽略网络接口检查错误
  }

  return false;
}

/**
 * Linux/Unix系统下的Docker检测
 * @returns {boolean} true表示在Docker中运行
 */
function isDockerOnLinux() {
  // 方法1: 检查/.dockerenv文件
  if (fs.existsSync('/.dockerenv')) {
    console.log('[ENV-SETUP] Detected Docker environment (Linux): /.dockerenv exists');
    return true;
  }

  // 方法2: 检查/proc/1/cgroup文件
  const cgroupPath = '/proc/1/cgroup';
  if (fs.existsSync(cgroupPath)) {
    const cgroupContent = fs.readFileSync(cgroupPath, 'utf8');
    if (cgroupContent.includes('docker') || cgroupContent.includes('/docker/')) {
      console.log('[ENV-SETUP] Detected Docker environment (Linux): cgroup contains docker');
      return true;
    }
  }

  // 方法3: 检查/proc/self/mountinfo文件
  const mountinfoPath = '/proc/self/mountinfo';
  if (fs.existsSync(mountinfoPath)) {
    const mountinfoContent = fs.readFileSync(mountinfoPath, 'utf8');
    if (mountinfoContent.includes('docker')) {
      console.log('[ENV-SETUP] Detected Docker environment (Linux): mountinfo contains docker');
      return true;
    }
  }

  // 方法4: 检查环境变量
  if (process.env.container === 'docker' || process.env.DOCKER_CONTAINER) {
    console.log('[ENV-SETUP] Detected Docker environment (Linux): environment variables');
    return true;
  }

  // 方法5: 检查主机名格式(Docker容器通常有12位随机主机名)
  const hostname = os.hostname();
  if (hostname && hostname.length === 12 && /^[0-9a-f]+$/.test(hostname)) {
    console.log(`[ENV-SETUP] Detected Docker environment (Linux): hostname pattern ${hostname}`);
    return true;
  }

  return false;
}

/**
 * 更新.env文件中的SERVICE_BASE_URL
 * @param {string} baseUrl 要设置的URL
 */
function updateServiceBaseUrl(baseUrl) {
  // 跨平台的路径处理
  let currentDir;
  if (os.platform() === 'win32') {
    // Windows: file:///E:/path/to/file -> E:\path\to\file
    currentDir = path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Z]:)/, '$1'));
  } else {
    // Linux/Unix: file:///path/to/file -> /path/to/file  
    currentDir = path.dirname(new URL(import.meta.url).pathname);
  }
  
  const envPath = path.join(currentDir, '../.env');
  console.log(`[ENV-SETUP] .env file path: ${envPath}`);
  
  let envContent = '';
  
  // 读取现有的.env文件
  if (fs.existsSync(envPath)) {
    envContent = fs.readFileSync(envPath, 'utf8');
  }

  // 更新或添加SERVICE_BASE_URL
  const serviceBaseUrlRegex = /^SERVICE_BASE_URL=.*$/m;
  const newLine = `SERVICE_BASE_URL="${baseUrl}"`;

  if (serviceBaseUrlRegex.test(envContent)) {
    // 更新现有行
    envContent = envContent.replace(serviceBaseUrlRegex, newLine);
  } else {
    // 添加新行
    envContent += envContent.endsWith('\n') ? '' : '\n';
    envContent += `# 后端的基础路径 - 自动根据环境设置\n${newLine}\n`;
  }

  // 写回文件
  fs.writeFileSync(envPath, envContent, 'utf8');
  console.log(`[ENV-SETUP] Updated .env file: SERVICE_BASE_URL="${baseUrl}"`);
}

/**
 * 主函数
 */
function main() {
  console.log('[ENV-SETUP] Starting environment detection...');

  // 检测运行环境
  const inDocker = isRunningInDocker();
  
  if (inDocker) {
    // Docker环境：使用空字符串(相对路径，通过nginx代理)
    console.log('[ENV-SETUP] Docker environment detected');
    updateServiceBaseUrl('');
  } else {
    // 非Docker环境：使用localhost:8081
    console.log('[ENV-SETUP] Local development environment detected');
    updateServiceBaseUrl('http://localhost:8081');
  }

  console.log('[ENV-SETUP] Environment setup completed');
}

/**
 * 检测是否直接运行此脚本
 * @returns {boolean} true表示直接运行
 */
function isMainModule() {
  if (!import.meta.url.startsWith('file://') || !process.argv[1]) {
    return false;
  }
  
  // 跨平台的路径比较
  let scriptPath;
  if (os.platform() === 'win32') {
    scriptPath = new URL(import.meta.url).pathname.replace(/^\/([A-Z]:)/, '$1').replace(/\//g, '\\');
  } else {
    scriptPath = new URL(import.meta.url).pathname;
  }
  
  const argv1Path = path.resolve(process.argv[1]);
  const resolvedScriptPath = path.resolve(scriptPath);
  
  return argv1Path === resolvedScriptPath;
}

// 如果直接运行此脚本
if (isMainModule()) {
  main();
}

export { detectOS, isRunningInDocker, updateServiceBaseUrl };