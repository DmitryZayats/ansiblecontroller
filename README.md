# ansiblecontroller

## Building container image

To build container image

```
docker build -t ansiblecontroller:version .
```

Example:
```
docker build -t ansiblecontroller:12-03-2025 .
```

## Export and distribute to a target system

On source system export image

```
docker save ansiblecontroller:version | gzip > ansiblecontroller:version.tar.gz
```

Example:
```
docker save ansiblecontroller:12-03-2025 | gzip > ansiblecontroller:12-03-2025.tar.gz
```

To load image on the target system (my target system does not have docker, but it has podman)

```
podman load -i ansiblecontroller:version.tar.gz
```

## Start on target system

Make sure to map your local directory properly, it just so happens that I'm mapping /root/ansible on the host to /ansible inside container

```
podman run -d --name=ansible-version -v /root/ansible:/ansible ansiblecontroller:version
```

## VIM settings for editing yaml files

Place below lines in your ~/.vimrc
```
syntax enable
filetype plugin indent on 
autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
```
where  
- syntax enable: Enables syntax highlighting.
- filetype plugin indent on: Activates file type detection and loads the appropriate plugins and indent settings.
- setlocal ts=2: Sets the tab stop to 2 spaces, which is standard for YAML.
- setlocal sts=2: Sets the soft tab stop to 2 spaces.
- setlocal sw=2: Sets the shift width for auto-indentation to 2 spaces.
- expandtab: Converts tabs to spaces, which is crucial for YAML formatting.
- indentkeys-=0#: Prevents Vim from re-indenting lines after inserting a comment character (#), which can disrupt the structure of YAML files.
