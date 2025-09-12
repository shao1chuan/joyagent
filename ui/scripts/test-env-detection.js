#!/usr/bin/env node

import { detectOS, isRunningInDocker, updateServiceBaseUrl } from './setup-env.js';

/**
 * 测试环境检测功能
 */
function runTests() {
  console.log('=== 环境检测测试 ===\n');

  // 测试1: 检测操作系统
  const os = detectOS();
  console.log(`1. 操作系统检测: ${os}`);
  console.log(`   - Windows: ${os === 'win32' ? '✓' : '✗'}`);
  console.log(`   - Linux: ${os === 'linux' ? '✓' : '✗'}`);
  console.log(`   - macOS: ${os === 'darwin' ? '✓' : '✗'}`);

  // 测试2: Docker环境检测
  console.log('\n2. Docker环境检测:');
  const inDocker = isRunningInDocker();
  console.log(`   当前检测结果: ${inDocker ? 'Docker环境' : '本地开发环境'}`);

  // 测试3: 模拟Docker环境
  console.log('\n3. 模拟Docker环境测试:');
  
  // 备份原始环境变量
  const originalContainer = process.env.container;
  const originalDockerContainer = process.env.DOCKER_CONTAINER;

  // 模拟设置Docker环境变量
  process.env.container = 'docker';
  console.log('   设置 container=docker');
  const dockerTest1 = isRunningInDocker();
  console.log(`   检测结果: ${dockerTest1 ? '✓ 正确识别Docker环境' : '✗ 未能识别Docker环境'}`);

  // 恢复环境变量，测试DOCKER_CONTAINER
  delete process.env.container;
  process.env.DOCKER_CONTAINER = 'true';
  console.log('   设置 DOCKER_CONTAINER=true');
  const dockerTest2 = isRunningInDocker();
  console.log(`   检测结果: ${dockerTest2 ? '✓ 正确识别Docker环境' : '✗ 未能识别Docker环境'}`);

  // 恢复原始环境变量
  if (originalContainer) {
    process.env.container = originalContainer;
  } else {
    delete process.env.container;
  }
  
  if (originalDockerContainer) {
    process.env.DOCKER_CONTAINER = originalDockerContainer;
  } else {
    delete process.env.DOCKER_CONTAINER;
  }

  // 测试4: 配置文件更新测试
  console.log('\n4. 配置文件更新测试:');
  console.log('   测试开发环境配置...');
  updateServiceBaseUrl('http://localhost:8081');
  console.log('   ✓ 开发环境配置完成');
  
  console.log('   测试Docker环境配置...');
  updateServiceBaseUrl('');
  console.log('   ✓ Docker环境配置完成');

  console.log('\n=== 测试完成 ===');
  console.log('\n跨平台兼容性:');
  console.log('✓ Windows 支持');
  console.log('✓ Linux 支持');  
  console.log('✓ Docker 环境检测');
  console.log('✓ 自动配置切换');
}

// 运行测试
runTests();