# Find Mailgun DNS Records

Search AWS for DNS records that refer to mailgun.

## Dependencies

* nodejs
* bash
* aws-cli

## Usage

### Search all environments:

```
make
```

### Search a particular environment:

```
make <env/app>
```

e.g.

```
make prod/vault
```

## Results

After running, all of the domains that are associated with mailgun will be listed in the `all-domains.txt` file.

Per-environment results can be found in the `results` directory.
