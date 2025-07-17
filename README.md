# Efficient Memory Sharing Between CPU and GPU in Gem5

**Authors**: Stephen Singh, Austin Kee, Thomas Tymecki, Andrew Femiano :contentReference[oaicite:0]{index=0}

---

## Table of Contents

- [Overview](#overview)  
- [Objectives](#objectives)  
- [Proposed Approach](#proposed-approach)  
- [System Architecture](#system-architecture)  
  - [GPGPU Model](#gpgpu-model)  
  - [Full-System AMD GPU Model](#full-system-amd-gpu-model)  
  - [Gem5-GPU Model](#gem5-gpu-model)  
  - [GCN3 GPU Model](#gcn3-gpu-model)  
- [Progress & Roadblocks](#progress--roadblocks)  
- [Results](#results)  
- [Comparison & Analysis](#comparison--analysis)  
- [Limitations](#limitations)  
- [Future Work](#future-work)  
- [Getting Started](#getting-started)  
 

---

## Overview

This project explores efficient heterogeneous memory sharing and cache coherence mechanisms between CPU and GPU within the Gem5 simulator. By modeling unified memory access and evaluating cache behaviors, we aim to identify optimal configurations for mixed workloads. :contentReference[oaicite:1]{index=1}

## Objectives

1. Develop a shared-memory model leveraging both CPU and GPU caches.  
2. Design and evaluate mechanisms for unified memory access and cache coherence within Gem5. :contentReference[oaicite:2]{index=2}

## Proposed Approach

- Build a heterogeneous CPU–GPU system in Gem5.  
- Integrate shared TLB management and cache-coherence protocols.  
- Perform performance analysis under standard and custom APU workloads. :contentReference[oaicite:3]{index=3}

## System Architecture

### GPGPU Model

- **Heterogeneous System Architecture** with detailed GPU computation blocks.  
- **CUDA Toolkit** support for NVIDIA drivers (Ubuntu ≤ 16.04, CUDA 8.0).  
- **Built-in Gem5 samples** for cache-coherence statistics. :contentReference[oaicite:4]{index=4}

### Full-System AMD GPU Model

- **x86 CPU + AMD GPU** heterogeneous simulation using KVM.  
- **ROCm integration** for OpenCL and HIP workloads.  
- Actively maintained community support for full-system AMD GPUs. :contentReference[oaicite:5]{index=5}

### Gem5-GPU Model

- **Detailed heterogeneous models** built on up-to-date Gem5 builds.  
- **OpenCL support** for parallel kernels.  
- Requires custom Gem5 configuration files for cache models. :contentReference[oaicite:6]{index=6}

### GCN3 GPU Model

1. **Compute Units (CUs)**  
   - Scalar Units for lightweight operations  
   - SIMD Units for vectorized parallelism  
   - LDS (Local Data Store) for intra-CU sharing  
2. **Memory Hierarchy**  
   - Private, Shared, and Global memory regions  
   - Simulated latency, bandwidth, and contention  
3. **HSA (hUMA) Support** for unified CPU–GPU memory space  
4. **ROCm Integration** enabling realistic execution of OpenCL/HIP workloads  
5. **AMD GCN3 ISA** implementation including ALU, branching, and memory ops  
6. **Full-System Simulation** capability for end-to-end heterogeneous workloads :contentReference[oaicite:7]{index=7}

## Progress & Roadblocks

- **GPGPU**  
  - Difficult setup on VMware; CUDA limited to Ubuntu 16.04/CUDA 8.0.  
  - Sparse documentation for Linux GPU configuration.  
- **Full-System AMD GPU**  
  - Requires KVM expertise; long simulation times; few ready-to-use samples.  
- **Gem5-GPU**  
  - Outdated past Ubuntu 16.04; poor compatibility; custom config files needed. :contentReference[oaicite:8]{index=8}

## Results

### Standard APU Workload

| Cache      | Demand Hits | Demand Misses | Hit Rate  |
|------------|-------------|---------------|-----------|
| **L1DCache** | ~10.31 M     | ~0.454 M       | ~95.8 %   |
| **L1ICache** | ~51.45 M     | ~0.047 M       | ~99.9 %   |

### Custom APU Workload

| Cache      | Demand Hits | Demand Misses | Hit Rate  |
|------------|-------------|---------------|-----------|
| **L1DCache** | 24,481       | 655           | ~97.4 %   |
| **L1ICache** | 93,023       | 626           | ~99.3 %   | :contentReference[oaicite:9]{index=9}

## Comparison & Analysis

- **Efficiency vs. Activity**  
  - Standard workload shows higher cache activity (more overhead).  
  - Custom workload yields slightly higher hit rates with less overhead.  
- **Hit/Miss Ratios**  
  - L1D: 95.8 % vs. 97.4 %; L1I: 99.9 % vs. 99.3 %.  
- **Choosing a Setup**  
  - Use **Standard APU** for stress-testing.  
  - Use **Custom APU** for efficient, coherent access under lighter loads. :contentReference[oaicite:10]{index=10}

## Limitations

- Gem5’s **AtomicSimpleCPU** and **X86KvmCPU** only; timing CPUs aren’t GPU-coherent.  
- Lack of detailed CPU timing models limits interpretation to ideal access scenarios. :contentReference[oaicite:11]{index=11}

## Future Work

- Extend Gem5 to include **CPU timing support** alongside GPU modeling.  
- Enhance **Garnet 2.0** with a simplified GPU network model.  
- Enable **parameter customization** (e.g., `dgpu_mem_size`) on simulated devices.  
- Investigate **unified memory** and **zero-copy** architectures for emerging heterogeneous platforms. :contentReference[oaicite:12]{index=12}

## Getting Started

1. **Prerequisites**  
   - Linux (Ubuntu 16.04 recommended)  
   - Gem5 v21.2 or later  
   - CUDA 8.0 (for NVIDIA models) and/or ROCm (for AMD models)  

2. **Clone the Repository**  
   ```bash
   git clone https://github.com/yourusername/gem5-hetero-memory.git
   cd gem5-hetero-memory
