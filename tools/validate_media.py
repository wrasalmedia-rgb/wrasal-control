#!/usr/bin/env python3
"""WRASAL-ARENA-CIN-001 — server-side media validation beyond container signature.

The ftyp magic only says a file resembles MP4. This validator opens the container,
checks stream/codec/dimension/duration policy, and DECODES head+tail frames to
prove the file is complete and safe to process. Emits JSON; exit 0 = valid.
Uses PyAV from tools/pylibs (provisioned by scripts/setup-encoder.sh).
"""
import json
import sys
import os

ALLOWED_CODECS = {'h264', 'vp9', 'av1'}
MAX_W, MAX_H = 4096, 2304
MIN_DUR, MAX_DUR = 0.5, 60.0
HEAD, TAIL = 24, 24


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else ''
    sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), 'pylibs'))
    out = {'ok': False, 'reasons': [], 'file': path}
    try:
        import av
        c = av.open(path)
        vs = [s for s in c.streams if s.type == 'video']
        if len(vs) != 1:
            out['reasons'].append(f'expected exactly 1 video stream, got {len(vs)}')
        else:
            s = vs[0]
            out.update(container=c.format.name, codec=s.codec_context.name, width=s.width,
                       height=s.height, pix_fmt=s.codec_context.pix_fmt)
            if s.codec_context.name not in ALLOWED_CODECS:
                out['reasons'].append(f'codec {s.codec_context.name} not in allowlist {sorted(ALLOWED_CODECS)}')
            if s.width > MAX_W or s.height > MAX_H or s.width % 2 or s.height % 2:
                out['reasons'].append(f'dimensions {s.width}x{s.height} outside policy (<= {MAX_W}x{MAX_H}, even)')
            dur = float(s.duration * s.time_base) if s.duration else float(c.duration) / av.time_base if c.duration else 0.0
            out['duration_s'] = round(dur, 3)
            if not (MIN_DUR <= dur <= MAX_DUR):
                out['reasons'].append(f'duration {dur:.2f}s outside {MIN_DUR}-{MAX_DUR}s')
            decoded = 0
            for i, frame in enumerate(c.decode(video=0)):
                decoded += 1
                if i + 1 >= HEAD:
                    break
            out['frames_decoded_head'] = decoded
            if decoded < min(HEAD, 2):
                out['reasons'].append('head decode failed (truncated or corrupt)')
            c.seek(max(0, int((dur - 1.0) * av.time_base)) if dur > 1.5 else 0)
            tail = 0
            for frame in c.decode(video=0):
                tail += 1
                if tail >= TAIL:
                    break
            out['frames_decoded_tail'] = tail
            if tail < 1:
                out['reasons'].append('tail decode failed (truncated file)')
        c.close()
        out['ok'] = not out['reasons']
    except Exception as e:  # noqa: BLE001
        out['reasons'].append(f'validation error: {e}')
    print(json.dumps(out))
    sys.exit(0 if out['ok'] else 3)


if __name__ == '__main__':
    main()
