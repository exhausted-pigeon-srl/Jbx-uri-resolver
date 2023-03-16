# Jbx-uri-resolver
Custom tokenURI resolver for Juicebox 721Delegate projects

https://juicebox.money/@exhausted-pigeon
https://opensea.io/collection/exhausted-pigeons


Shuffle in bash, following Juicebox tier formats: 
```bash
ls | shuf | cat -n | while read n f; do mv -n "$f" 1\`printf "%09d.png" $n\`; done
```


To not randomize asset, remove `| shuf` from the command.