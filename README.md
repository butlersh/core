# Butlersh Core

Script and configuration files for server management.

## Usage

On a Ubuntu server, download the **security-setup.sh** script.

```bash
wget -qO- "https://raw.githubusercontent.com/butlersh/core/main/scripts/security-setup.sh" > security-setup.sh
```

Make it executable

```bash
chmod +x security-setup.sh
```

Run it with some options

```bash
./security-setup.sh --user=forge
```

Here are other available scripts and their options.

```bash
./nginx-setup.sh --user=forge

./php-setup.sh --user=forge --group=forge --version=8.4

./mysql-setup.sh --version=8.0
```

## License (MIT)

The MIT License (MIT). Please see the [License](./LICENSE.md) for more information.
