# Build 
```shell
sozo build
```
# Test
```shell
sozo test
```
# Migrate/deployment 
Spin up katana:
```shell
katana --disable-fee
```
In a separate terminal, run : 
```shell
sozo migrate
```
# interaction
```shell
sozo execute <ContractAddress> <entrypoint>

with argument

sozo execute <ContractAddress> <entrypoint> --calldata 
```

todo: gate initialize fn & mint fn.