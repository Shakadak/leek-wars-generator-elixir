#!/usr/bin/env python3

import json
import os
import struct
import sys

def port_read():
    in_fd = sys.stdin.fileno()
    b = os.read(in_fd, 4)#buffer.read(4)
    size, = struct.unpack('>i', b)
    data = os.read(sys.stdin.fileno(), size)
    return json.loads(data.decode('utf-8'))

def port_write(data):
    out_fd = sys.stdout.fileno()
    data = json.dumps(data)
    size = struct.pack('>i', len(data))
    os.write(out_fd, size)
    os.write(out_fd, data.encode('utf-8'))

if __name__ == '__main__':
    state = port_read()
    port_write({"action": "move", "cell": 360})
    port_read()
