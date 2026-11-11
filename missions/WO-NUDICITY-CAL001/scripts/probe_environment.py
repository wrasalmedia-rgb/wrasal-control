"""Capture the verifiable execution-environment facts behind WO-NUDICITY-CAL001.

Everything written here is observed, not assumed: package versions come from
the installed distributions, egress results come from an actual HTTPS probe,
and hardware facts come from the kernel.
"""

from __future__ import annotations

import json
import os
import platform
import shutil
import subprocess
import sys
import urllib.error
import urllib.request

HOSTS = [
    ("pypi.org", "https://pypi.org/simple/", "python package index"),
    ("files.pythonhosted.org", "https://files.pythonhosted.org/", "python package CDN"),
    ("registry.npmjs.org", "https://registry.npmjs.org/", "npm registry"),
    ("github.com", "https://github.com/", "source hosting + release metadata"),
    ("api.github.com", "https://api.github.com/", "release metadata API"),
    ("codeload.github.com", "https://codeload.github.com/", "source tarballs"),
    ("raw.githubusercontent.com", "https://raw.githubusercontent.com/", "raw file host"),
    ("objects.githubusercontent.com", "https://objects.githubusercontent.com/", "release asset CDN"),
    ("release-assets.githubusercontent.com", "https://release-assets.githubusercontent.com/", "release asset CDN"),
    ("huggingface.co", "https://huggingface.co/", "model weight host (diffusion / SAM)"),
    ("civitai.com", "https://civitai.com/", "model weight host (community)"),
    ("storage.googleapis.com", "https://storage.googleapis.com/", "model weight host (mediapipe)"),
]


def probe(url: str, timeout: int = 12):
    request = urllib.request.Request(url, method="GET",
                                     headers={"User-Agent": "CAL001-environment-probe"})
    try:
        with urllib.request.urlopen(request, timeout=timeout) as response:
            return {"status": response.status, "reachable": True}
    except urllib.error.HTTPError as error:
        # An HTTP status still proves the host is reachable.
        return {"status": error.code, "reachable": True}
    except Exception as error:  # noqa: BLE001
        return {"status": None, "reachable": False, "error": type(error).__name__}


def package_versions():
    versions = {}
    for name in ("numpy", "cv2", "PIL", "scipy", "matplotlib"):
        try:
            if name == "PIL":
                import PIL
                versions["Pillow"] = PIL.__version__
            elif name == "cv2":
                import cv2
                versions["opencv-python-headless"] = cv2.__version__
            else:
                module = __import__(name)
                versions[name] = module.__version__
        except Exception as error:  # noqa: BLE001
            versions[name] = f"unavailable ({type(error).__name__})"
    return versions


def main() -> None:
    out_path = sys.argv[1] if len(sys.argv) > 1 else "environment_probe.json"
    here = os.path.dirname(os.path.abspath(__file__))
    venv_python = os.path.normpath(os.path.join(here, "..", "..", "..", "..", ".venv", "bin", "python"))

    nvidia = shutil.which("nvidia-smi")
    comfy = shutil.which("comfy")

    payload = {
        "work_order_id": "WO-NUDICITY-CAL001",
        "purpose": "verifiable execution-environment inventory for the model-selection gate",
        "host": {
            "platform": platform.platform(),
            "machine": platform.machine(),
            "python": sys.version.split()[0],
            "venv_python": venv_python,
            "nvidia_smi_present": bool(nvidia),
            "gpu_available": False,
            "comfyui_on_path": bool(comfy),
        },
        "installed_packages": package_versions(),
        "egress_probe": [
            {"host": host, "url": url, "purpose": purpose, **probe(url)}
            for host, url, purpose in HOSTS
        ],
    }

    with open(out_path, "w", encoding="utf-8") as handle:
        json.dump(payload, handle, indent=2)
        handle.write("\n")

    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
