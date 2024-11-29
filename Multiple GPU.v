from m5.objects import *
from gem5.runtime import get_runtime_isa
from gem5.simulate.simulator import Simulator
from gem5.resources.resource import CustomResource

# Simulation Configuration for Multi-GPU
class MultiGPUConfig:
    def __init__(self):
        self.cpu_type = "TimingSimpleCPU"
        self.num_cpus = 4
        self.gpu_type = "SimpleGPUMem"
        self.num_gpus = 2  # Number of GPUs
        self.num_compute_units = 8  # Compute units per GPU
        self.shared_memory_size = "64kB"  # Shared memory size per GPU
        self.clock = "2GHz"
        self.mem_size = "8GB"

# Define the system
def create_system(config):
    system = System()

    # Setup CPU
    system.cpu = [TimingSimpleCPU() for _ in range(config.num_cpus)]
    system.clk_domain = SrcClockDomain(clock=config.clock, voltage_domain=VoltageDomain())

    # Setup GPUs
    system.gpus = []
    for i in range(config.num_gpus):
        gpu = SimpleGPUMem()
        gpu.num_compute_units = config.num_compute_units
        gpu.clk_domain = SrcClockDomain(clock="1GHz", voltage_domain=VoltageDomain())
        system.gpus.append(gpu)

    # Setup memory
    system.mem_ranges = [AddrRange(config.mem_size)]
    system.membus = SystemXBar()
    system.system_port = system.membus.cpu_side_ports

    # Shared memory configuration
    system.shared_mem = SharedMemory(
        size=config.shared_memory_size,
        latency="10ns"
    )

    # Connect CPUs to shared memory
    for cpu in system.cpu:
        cpu.icache_port = system.shared_mem.mem_side_ports
        cpu.dcache_port = system.shared_mem.mem_side_ports

    # Connect GPUs to shared memory
    for gpu in system.gpus:
        gpu.shared_mem_port = system.shared_mem.cpu_side_ports

    # Cache configuration
    system.l2cache = Cache(size="4MB", assoc=16)
    system.l2cache.cpu_side = system.membus.mem_side_ports
    system.l2cache.mem_side = system.shared_mem.cpu_side_ports

    return system

# Instantiate the simulator
def run_simulation():
    config = MultiGPUConfig()
    system = create_system(config)

    # Add a workload (example CUDA/OpenCL binary)
    binary = CustomResource("/path/to/your/binary")
    process = Process(cmd=[binary.path])
    system.cpu[0].workload = process
    system.cpu[0].createThreads()

    root = Root(full_system=False, system=system)
    simulator = Simulator(root)
    simulator.run()

if __name__ == "__main__":
    run_simulation()
