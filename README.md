Make screencast working on Firefox and wayland with pipewire on focal

```bash
podman build -f Containerfile -t focal-wayland-pipewire .
mkdir debs
podman run -it --rm --mount type=bind,src=./debs,target=/debs focal-wayland-pipewire bash -c 'cp /src/*.deb /debs'
# install mutter and its dependencies or all packages with the following command
sudo dpkg -i debs/*.deb
```
