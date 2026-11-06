#!/usr/bin/env python3
"""WRASAL-ARENA-CIN-001 plate-render tech-viz adapter.

Renders a real, playable H.264/MP4 camera-move test from a production plate:
smooth push-in (per shot DNA camera grammar) + film-grain noise pass.
This is TECHNICAL VISUALIZATION, not AI generation: it proves the production
pipeline (ingest -> job -> encode -> monitor -> review -> export) with real
video bytes while authorized AI providers remain credential-gated.

Encoder: PyAV (libx264) provisioned by scripts/setup-encoder.sh into tools/pylibs.
Frames are composited with ImageMagick and piped raw rgb24 into the encoder.
"""
import argparse
import os
import subprocess
import sys


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--plate', required=True)
    ap.add_argument('--out', required=True)
    ap.add_argument('--width', type=int, default=960)
    ap.add_argument('--height', type=int, default=412)
    ap.add_argument('--duration', type=float, default=5.0)
    ap.add_argument('--fps', type=int, default=24)
    ap.add_argument('--zoom', type=float, default=0.02)
    ap.add_argument('--grain', type=float, default=0.35)
    a = ap.parse_args()

    sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), 'pylibs'))
    import av  # noqa: E402

    n = int(round(a.duration * a.fps))
    w, h = a.width, a.height
    container = av.open(a.out, 'w')
    stream = container.add_stream('libx264', rate=a.fps)
    stream.width, stream.height, stream.pix_fmt = w, h, 'yuv420p'
    stream.options = {'crf': '18', 'preset': 'medium'}

    for i in range(n):
        s = 1.0 + a.zoom * i / max(n - 1, 1)
        sw, sh = int(w * s), int(h * s)
        cmd = ['convert', a.plate,
               '-resize', f'{sw}x{sh}!', '-gravity', 'center',
               '-crop', f'{w}x{h}+0+0', '+repage']
        if a.grain > 0:
            cmd += ['-attenuate', str(a.grain), '+noise', 'Gaussian']
        cmd += ['-depth', '8', 'rgb:-']
        proc = subprocess.run(cmd, capture_output=True)
        raw = proc.stdout
        if len(raw) != w * h * 3:
            print(f'frame {i}: expected {w*h*3} bytes, got {len(raw)}; stderr={proc.stderr[-500:]!r}',
                  file=sys.stderr)
            sys.exit(2)
        frame = av.VideoFrame(w, h, 'rgb24')
        frame.planes[0].update(raw)
        for packet in stream.encode(frame):
            container.mux(packet)
    for packet in stream.encode():
        container.mux(packet)
    container.close()
    print(f'OK {n} frames {w}x{h}@{a.fps}fps zoom={a.zoom} grain={a.grain} -> {a.out}')


if __name__ == '__main__':
    main()
