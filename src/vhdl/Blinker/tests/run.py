import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock

import tkinter as tk
from datetime import datetime, timedelta
from time import sleep

led_color_on      = "lime"
led_color_off     = "dark slate gray"
led_color_invalid = "red"

refresh_time = timedelta(milliseconds=40)

class Gui:
    def __init__(self, dut):
        self.dut = dut

        self.root = tk.Tk()
        self.root.protocol("WM_DELETE_WINDOW", self.on_close)

        self.canvas = tk.Canvas(self.root, width=100, height=100, bg="black", relief="flat")
        self.canvas.pack(side=tk.BOTTOM)
        self.led = self.canvas.create_oval(10, 10, 90, 90, fill=led_color_off)

        self.closed = False
        self.last_update = datetime.now()

        self.root.update()

    def on_close(self):
        self.root.quit()
        self.closed = True

    def update(self):
        t = datetime.now()
        delta = t - self.last_update

        if delta >= refresh_time:
            self.last_update = t
            led = self.dut.leds_o.value.binstr[15]
            if led == '1':
                color = led_color_on
            elif led == '0':
                color = led_color_off
            else:
                color = led_color_invalid
            self.canvas.itemconfig(self.led, fill=color)

        self.root.update()

# Generate a clock that attempts to match the real time.
#
# trigger:       A Timer object corresponding to half a clock period
# burst_time:    A timedelta object corresponding to the duration of a burst of clock cycles
# burst_count:   The number of clock cycles in a burst
#
# Precondition: burst_time / burst_count == 2 * trigger
@cocotb.coroutine
def realtime_clock(sig, trigger, burst_time, burst_count):
    second = timedelta(seconds=1)

    while True:
        burst_start_time = datetime.now()
        for i in range(burst_count):
            sig <= 0
            yield trigger
            sig <= 1
            yield trigger
        burst_end_time = datetime.now()
        delta = burst_end_time - burst_start_time
        if delta < burst_time:
            sleep((burst_time - delta) / second)

@cocotb.test()
def run(dut):
    gui = Gui(dut)

    clk = realtime_clock(dut.clk_i, Timer(500, "us"), timedelta(milliseconds=10), 10)
    cocotb.fork(clk)

    while not gui.closed:
        yield Timer(10, "ms")
        gui.update()
