import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock

import tkinter as tk
from datetime import datetime, timedelta
from time import sleep
from math import floor

led_color_on      = "lime"
led_color_off     = "dark slate gray"
led_color_invalid = "red"

refresh_time = timedelta(milliseconds=40)

led_count  = 16
led_radius = 10
led_margin = 5
sw_cursor_height = 16
sw_height  = 40

led_width = 2 * (led_radius + led_margin)

class Gui:
    def __init__(self, dut):
        self.dut = dut

        self.root = tk.Tk()
        self.root.protocol("WM_DELETE_WINDOW", self.on_close)

        self.canvas = tk.Canvas(self.root, width=led_count * led_width, height=led_width+sw_height, bg="black", relief="flat")
        self.canvas.pack(side=tk.BOTTOM)
        self.canvas.create_rectangle(0, led_width, led_count * led_width - 1, led_width + sw_height - 1, fill="light gray")
        self.leds = [self.canvas.create_oval(i * led_width + led_margin, led_margin, (i + 1) * led_width - led_margin, led_width - led_margin, fill=led_color_off) for i in range(led_count)]
        self.sws  = [self.canvas.create_rectangle(i * led_width + led_margin, led_width + sw_height - sw_cursor_height - led_margin, (i + 1) * led_width - led_margin, led_width + sw_height - led_margin, fill="black") for i in range(led_count)]

        self.sw_states = 0
        self.canvas.bind("<Button-1>", self.on_sw_click)

        self.closed = False
        self.last_update = datetime.now()

        self.root.update()

    def on_close(self):
        self.root.quit()
        self.closed = True

    def on_sw_click(self, evt):
        if evt.y >= led_width:
            i = floor(evt.x / led_width)
            self.sw_states ^= 1 << (15 - i)

    def update(self):
        t = datetime.now()
        delta = t - self.last_update

        if delta >= refresh_time:
            self.last_update = t
            for i in range(-led_count, 0):
                led = self.dut.leds_o.value.binstr[i]
                if led == '1':
                    color = led_color_on
                elif led == '0':
                    color = led_color_off
                else:
                    color = led_color_invalid

                self.canvas.itemconfig(self.leds[i], fill=color)

                coords = self.canvas.coords(self.sws[i])
                if self.sw_states & (1 << (-i - 1)):
                    coords[1] = led_width + led_margin
                    coords[3] = led_width + led_margin + sw_cursor_height
                else:
                    coords[1] = led_width + sw_height - sw_cursor_height - led_margin
                    coords[3] = led_width + sw_height - led_margin
                self.canvas.coords(self.sws[i], coords)

            self.dut.switches_i <= self.sw_states

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

    dut.switches_i <= 0

    while not gui.closed:
        yield Timer(10, "ms")
        gui.update()
