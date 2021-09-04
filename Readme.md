# dotfiles

## Install

Run `./install.sh` from the directory.

## Options

Some options available! Check them out with `./install.sh --help`.

## Firmando commits

`git identity me@example.com`

### Importando claves de github

Para los merges:

```bash
curl https://github.com/web-flow.gpg | gpg --import
gpg --edit-key noreply@github.com trust quit
gpg --lsign-key noreply@github.com
```

De otras personas:

```bash
curl https://github.com/web-flow.gpg | gpg --import
```

Estas claves hay que marcarlas como confiables y firmarlas localmente también,
y se puede hacer de la misma forma. Si se importan múltiples claves, se puede
usar el identificador en lugar del email (El identificador se puede ver en el
commit)
