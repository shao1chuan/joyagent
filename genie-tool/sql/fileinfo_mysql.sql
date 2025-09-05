/*
 Navicat Premium Data Transfer

 Source Server         : jeecg
 Source Server Type    : MySQL
 Source Server Version : 80019
 Source Host           : localhost:13306
 Source Schema         : genie_tool

 Target Server Type    : MySQL
 Target Server Version : 80019
 File Encoding         : 65001

 Date: 05/09/2025 17:40:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for fileinfo
-- ----------------------------
DROP TABLE IF EXISTS `fileinfo`;
CREATE TABLE `fileinfo`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `file_path` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `file_size` int NULL DEFAULT NULL,
  `status` int NOT NULL,
  `request_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `file_id`(`file_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fileinfo
-- ----------------------------
INSERT INTO `fileinfo` VALUES (1, '300e24ce0b6e3e89bcb75ad2406b8787', '分数阶微分定义原理应用领域数学基础最新研究进展_search_result.txt', 'file_db_dir\\geniesession-1756534624634-3275_1756534624647-7123\\分数阶微分定义原理应用领域数学基础最新研究进展_search_result.txt', '分数阶微分 定义 原理 应用领域 数学基础 最新研究进展...', 20066, 1, 'geniesession-1756534624634-3275:1756534624647-7123', '2025-08-30 06:17:45');
INSERT INTO `fileinfo` VALUES (2, 'fd285ae2ab8714946910883a262acfac', '分数阶微分定义原理应用领域数学基础最新研究进展的搜索结果.md', 'file_db_dir\\geniesession-1756534624634-3275_1756534624647-7123\\分数阶微分定义原理应用领域数学基础最新研究进展的搜索结果.md', '# 分数阶微分：定义、原理、应用领域、数学基础及最新研究进展\n\n## 1 引言与历史背景\n\n分数阶微积分（Fractional Calculus）作为数学分析的一个重要分支，其核心思想是将传统的整数阶微分和积分运算推广到任意实数阶甚至复数阶。这一概念的历史可以追溯到1695年，当时洛必达（L\'Hôpital）和莱布尼茨（Leibniz）在通信中首次讨论了\"半阶导数\"的含义[[6]](https://swarma.org/?p=45036)。此后三个世纪中，这一领域主要作为纯数学理论被数学家们研究，包括欧拉（Euler）、拉格朗日（Lagrange）、傅里叶（Fourier）、阿贝尔（Abel）、刘维尔（Liouville）和黎曼（Riemann）等著名数学家都对此做出了贡献[[18]](http://www.tup.com.cn/upload/books/yz/063351-01.pdf)。\n\n分数阶微积分狭义上主要包括分数阶微分与分数阶积分，广义上同时包括分数阶差分与分数阶和商[[5]](https://baike.baidu.com/item/%E5%88%86%E6%95%B0%E9%98%B6%E5%BE%AE%E7%A7%AF%E5%88%86/8404175)。近几十年来，随着分数阶微积分理论在各大领域中的成功应用，人们逐渐认识到分数阶微积分不仅具有深刻的数学内涵，更在描述复杂系统行为方面展现出独特优势[[5]](https://baike.baidu.com/item/%E5%88%86%E6%95%B0%E9%98%B6%E5%BE%AE%E7%A7%AF%E5%88%86/8404175)。\n\n分数阶微积分是任意实数阶或复数阶微分及积分理论的发展，它将经典微积分的基本运算扩展到分数阶，研究涉及这些分数阶导数和积分的微分方程的求解方法[[12]](http://reference.wolframcloud.com/language/tutorial/FractionalCalculus.html.zh?source=footer)。这一扩展使得数学家们能够用更精确的数学工具描述那些既不是完全局部也不是完全全局的物理现象，填补了整数阶微积分在描述复杂系统时的理论空白。\n\n## 2 分数阶微积分的数学基础\n\n### 2.1 基本概念与特殊函数\n\n分数阶微积分的基础建立在一些特殊函数之上，其中最重要的是Gamma函数。Gamma函数是阶乘函数在实数和复数范围内的扩展，定义为：\n\n$$\\Gamma(z) = \\int_0^\\infty t^{z-1}e^{-t}dt, \\quad \\text{Re}(z) > 0$$\n\nGamma函数为分数阶微积分提供了必要的数学工具，使得非整数阶的微分和积分运算成为可能[[11]](https://zhuanlan.zhihu.com/p/648836770)。另一个重要函数是Mittag-Leffler函数，它是指数函数的推广，在分数阶微分方程的解中扮演着核心角色。\n\n分数阶微积分的基本思想可以通过考察指数函数的分数阶导数来直观理解。对于函数$e^{ax}$，其整数阶导数有$\\mathrm{d}e^{ax}=ae^{ax}$，$\\mathrm{d}^{2}e^{ax}=a^{2}e^{ax}$，依此类推。很自然地，我们可以将这一规律推广到任意阶数$\\alpha$，得到$\\mathrm{d}^{\\alpha}e^{ax}=a^{\\alpha}e^{ax}$[[11]](https://zhuanlan....', 15880, 1, 'geniesession-1756534624634-3275:1756534624647-7123', '2025-08-30 06:20:56');
INSERT INTO `fileinfo` VALUES (3, '6ce0a6e9cc575b65ff886f606c2cc786', '分数阶微分全面总结报告.html', 'file_db_dir\\geniesession-1756534624634-3275_1756534624647-7123\\分数阶微分全面总结报告.html', '\n<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n    <meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <title>分数阶微积分：从数学理论到多学科应用的全面探索</title>\n    <script', 15055, 1, 'geniesession-1756534624634-3275:1756534624647-7123', '2025-08-30 06:24:17');
INSERT INTO `fileinfo` VALUES (4, 'd4ff25232238996f692ae5e880b1804d', '分数阶微分发明专利技术领域应用场景创新点最新研究进展_search_result.txt', 'file_db_dir\\geniesession-1756791928207-7322_1756791928221-2938\\分数阶微分发明专利技术领域应用场景创新点最新研究进展_search_result.txt', '分数阶微分 发明专利 技术领域 应用场景 创新点 最新研究进展...', 18966, 1, 'geniesession-1756791928207-7322:1756791928221-2938', '2025-09-02 05:46:03');
INSERT INTO `fileinfo` VALUES (5, '2895392ce97e8ec0a13b682c1d3412b2', '分数阶微分发明专利技术领域应用场景创新点最新研究进展的搜索结果.md', 'file_db_dir\\geniesession-1756791928207-7322_1756791928221-2938\\分数阶微分发明专利技术领域应用场景创新点最新研究进展的搜索结果.md', '好的，我将根据您提供的知识库内容，为您生成一份关于分数阶微分发明专利技术领域、应用场景、创新点及最新研究进展的详细报告。\n\n# 分数阶微分发明专利技术领域、应用场景、创新点及最新研究进展综合分析报告\n\n## 第一章 分数阶微分理论概述与研究意义\n\n### 1.1 分数阶微分的基本概念\n\n分数阶微分是整数阶微分的推广，它通过引入非整数阶的微分算子来扩展传统微积分的应用范围。与整数阶微分相比，分数阶微分算子具有**非局部性**和**历史依赖性**的特点，能够更好地描述具有记忆和遗传特性的复杂系统。这种特性使得分数阶微分在建模复杂物理现象和工程问题时表现出独特优势[[11]](https://www.izaiwen.cn/detail.MzgxMjU%3D.html)。\n\n分数阶微分算子的数学定义有多种形式，其中最常见的是Riemann-Liouville定义和Caputo定义。Riemann-Liouville分数阶微分定义为：\n$$D^\\alpha f(t) = \\frac{1}{\\Gamma(n-\\alpha)} \\frac{d^n}{dt^n} \\int_a^t \\frac{f(\\tau)}{(t-\\tau)^{\\alpha-n+1}} d\\tau$$\n其中$n-1 < \\alpha < n$，$\\Gamma(\\cdot)$为Gamma函数。而Caputo定义则表示为：\n$$^C D^\\alpha f(t) = \\frac{1}{\\Gamma(n-\\alpha)} \\int_a^t \\frac{f^{(n)}(\\tau)}{(t-\\tau)^{\\alpha-n+1}} d\\tau$$\n这两种定义在初始条件处理上有所不同，适用于不同的应用场景[[15]](https://conf.orsc.org.cn/storage/files/20250813/y2qX3WUJ482b1njWG8kjCyHEuJrGE5auWOw8AecK.pdf)。\n\n### 1.2 分数阶微分的研究价值\n\n分数阶微分理论的研究具有重要的理论意义和实际价值。从理论层面看，分数阶微分方程是数学中一个**既有深刻理论意义又有广泛应用价值**的研究方向，它丰富了现代数学理论体系，为描述复杂系统提供了新的数学工具[[16]](https://s.wanfangdata.com.cn/paper?q=%E4%BD%9C%E8%80%85:%22%E9%97%AB%E5%87%A4%E4%B8%BD%22)。\n\n从应用层面看，分数阶微分模型被广泛应用于**物理、材料、金融**等诸多领域。由于其非局部特性，分数阶模型能够更准确地描述反常扩散过程、粘弹性材料力学行为、金融市场的长记忆性等现象[[11]](https://www.izaiwen.cn/detail.MzgxMjU%3D.html)。此外，分数阶微分在**信号处理、图像处理、控制系统**等领域也展现出显著优势，成为跨学科研究的重要工具。\n\n## 第二章 分数阶微分技术专利分析\n\n### 2.1 控制器设计领域的专利技术\n\n在控制器设计领域，分数阶微分技术已经产生了重要的发明专利。CN103558755B专利提出了一种**带有分数阶积分的PID控制器整定和自整定实现方法**。该发明的具体实施步骤如下：首先适当地选取Bode理想传递函数阶次β和幅值穿越频率ωc，建立Bode理想传递函数；然后根据Bode理想截止特性，确定分数阶PID控制器的参数整定规则；最后实现控制器的自整定功能[[1]](https://patents.goo...', 16854, 1, 'geniesession-1756791928207-7322:1756791928221-2938', '2025-09-02 05:49:25');
INSERT INTO `fileinfo` VALUES (6, 'def2fa2c4a251d0fa08120e28a1200b1', '分数阶微分发明专利技术报告.html', 'file_db_dir\\geniesession-1756791928207-7322_1756791928221-2938\\分数阶微分发明专利技术报告.html', '\n<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n    <meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <title>分数阶微分技术创新专利研究报告 - 前沿应用与未来发展</title>\n    <sc', 15802, 1, 'geniesession-1756791928207-7322:1756791928221-2938', '2025-09-02 05:52:56');
INSERT INTO `fileinfo` VALUES (7, '4378ac6009d2ffcd20d73db3d2e54d41', '2024年2025年14B参数以内开源多模态大模型评估对比_search_result.txt', 'file_db_dir\\geniesession-1757063775567-472_1757063838862-7597\\2024年2025年14B参数以内开源多模态大模型评估对比_search_result.txt', '2024年2025年14B参数以内开源多模态大模型评估对比...', 19391, 1, 'geniesession-1757063775567-472:1757063838862-7597', '2025-09-05 17:17:47');
INSERT INTO `fileinfo` VALUES (8, '4248a5d8ff481787ebee68dadbfce13f', '2024年2025年14B参数以内开源多模态大模型评估对比的搜索结果.md', 'file_db_dir\\geniesession-1757063775567-472_1757063838862-7597\\2024年2025年14B参数以内开源多模态大模型评估对比的搜索结果.md', '好的，我将根据您提供的知识库内容，为您生成一份关于2024-2025年14B参数以内开源多模态大模型评估对比的详细报告。\n\n# 2024-2025年14B参数以内开源多模态大模型评估对比报告\n\n## 执行摘要\n\n本报告旨在系统性地评估与对比2024年至2025年间发布的、参数规模在140亿（14B）以内的开源多模态大模型（Multimodal Large Language Models, MLLMs）。多模态大模型作为人工智能领域的前沿方向，其核心能力在于同时理解与处理多种类型的信息（如文本、图像、视频等），进而执行诸如视觉问答（VQA）、图像描述、视觉推理等复杂任务。[[19]](https://blog.csdn.net/m0_63294504/article/details/150070361) 报告将严格依据现有知识库提供的评测基准、模型性能数据和关键技术特征，从**模型架构**、**核心能力**、**基准测试表现**以及**发展趋势**等多个维度进行客观、中立的对比分析。分析表明，尽管模型性能不断提升，但即使在排名最高的模型中，其平均准确率也未能超过45%，类别准确率也未超过50%，这表明当前模型在达到人类级别的推理能力方面仍有很大差距。[[5]](https://zhuanlan.zhihu.com/p/717129017)\n\n## 第一章 多模态大模型评测体系概述\n\n要对多模态大模型进行有效的评估与对比，必须首先理解其评测基准体系。评测基准（Benchmark）是通过设计合理的测试任务和数据集来对模型能力进行全面、量化评估的核心工具。[[18]](https://www.caict.ac.cn/kxyj/qwfb/ztbg/202407/P020240711534708580017.pdf) 2024年至2025年，大模型基准测试数据集的数量持续攀升，针对多模态大模型的评测体系也日趋完善和细分。[[2]](https://www.caict.ac.cn/kxyj/qwfb/ztbg/202407/P020240711534708580017.pdf)\n\n### 1.1 主流多模态评测基准\n\n当前，业界存在多个广泛使用的多模态评测基准，它们从不同角度评估模型的能力。\n\n**MMBench**：由OpenCompass研究团队自建的视觉语言模型评测数据集，可实现从感知到认知能力逐级细分评估。其研究团队从互联网公开信息与权威基准数据集采集和构建了大量高质量的评测数据。[[4]](https://blog.csdn.net/OpenCompass/article/details/140955749) 该数据集覆盖了20个细粒度评估维度，能够全面评估多模态能力。[[6]](https://www.explinks.com/blog/yq-ua-large-model-ranking-2024-latest-large-language-model-evaluation/)\n\n**SEED-Bench**：专注于评估MLLMs的生成理解能力，作为对生成模型进行全面评估的初步步骤。SEED-Bench-2由三个层级构成，每个层级都对模型的不同能力进行了深度评估：L1评估模型对固定形式的图像（如单图、多图或视频）和文本的理解能力；L2评估模型对交错出现的图像和文本的理解能力；L3则评估模型的因果推理和反事实推理能力。[[10]](https://blog.csdn.net/qq_33523925/article/details/136780446)...', 16182, 1, 'geniesession-1757063775567-472:1757063838862-7597', '2025-09-05 17:21:27');
INSERT INTO `fileinfo` VALUES (9, '749476a1fe9a9cf1f47844578c12f48b', '14B以内开源多模态大模型评估报告.html', 'file_db_dir\\geniesession-1757063775567-472_1757063838862-7597\\14B以内开源多模态大模型评估报告.html', '\n<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n    <meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <title>2024-2025年14B参数开源多模态大模型深度评估报告</title>\n    <', 16448, 1, 'geniesession-1757063775567-472:1757063838862-7597', '2025-09-05 17:25:11');

SET FOREIGN_KEY_CHECKS = 1;
