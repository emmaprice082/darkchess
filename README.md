<!-- # TODO: FIX ENTIRE FILE FOR FOG OF WAR CHESS -->
# Deploying locally
1. amareleo-chain start
2. In your Leo directory, update your .env as follows:
      NETWORK=testnet
      PRIVATE_KEY=APrivateKey1zkp...GPWH
      ENDPOINT=http://localhost:3030
    For the Private Key, use a Private Key that ends in GPWH (which is automatically generated when you create a new Leo project using leo new PROJECT_NAME)

3.  Run `leo deploy` from the root of your Leo project directory will deploy the program to your local devnet.

4.  When you are ready to shutdown your devnet, press CTRL + C 

Note: Having the snarkos CLI would still be useful if you want to use tools like record scanning.




# Running locally

1. Create Venv
      `python3 -m venv leo_venv`
      `source leo_venv/bin/activate`
    You can spin up a local instance of Aleo using:
    - SnarkOS  
    - Amareleo

    Required tools: Leo CLI, SnarkOS CLI, tmux

2. From the root of the SnarkOS repo, on the `staging` branch, run:
      `devnet.sh` 
    (Alternatively, you can copy and past the script in your project directory.)

3.  Use the default options except for the one that asks to build the SnarkOS binary.  Also, clear the ledger history when redeploying a program (if you don't want to use a new name).
      Enter the total number of validators (default: 4): 
      Enter the total number of clients (default: 2): 
      Enter the network ID (mainnet = 0, testnet = 1, canary = 2) (default: 1): 
      Do you want to run 'cargo install --locked --path .' to build the binary? (y/n, default: y): n
      Do you want to clear the existing ledger history? (y/n, default: n): 
    NOTE:  You need to run at least 4 validator nodes in order to the run the devnet.

4.  In your Leo directory, update your .env as follows:
      NETWORK=testnet
      PRIVATE_KEY=APrivateKey1zkp...GPWH
      ENDPOINT=http://localhost:3030
    For the Private Key, use a Private Key that ends in GPWH (which is automatically generated when you create a new Leo project using leo new PROJECT_NAME)

5.  Running `leo deploy` from the root of your Leo project directory will deploy the program to your local devnet.

6.  When you are ready to shutdown your devnet, press CTRL + B + : and enter kill-session in the command line 


-----------------------------------------------------
# Installation Guide
### Install Leo
Repo: https://docs.leo-lang.org/getting_started/installation

1. `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
2. Download from source code: 
    ```
      # Download the source code
      git clone https://github.com/ProvableHQ/leo
      cd leo

      # Install 'leo'
      cargo install --path .
    ```

### Install SnarkOS
Repo: https://github.com/ProvableHQ/snarkOS

1. Install SnarkOS
    ```
      # IMPORTANT: Make sure rust version 1.83.0 is installed
      git clone --branch mainnet --single-branch https://github.com/ProvableHQ/snarkOS.git
      cd snarkOS
      git checkout tags/testnet-beta

      cargo install --locked --path .
    ```

### Install Amareleo
Repo: https://github.com/kaxxa123/amareleo-chain

1. Install Amareleo
  ```
    git clone https://github.com/kaxxa123/amareleo-chain.git
    cd amareleo-chain
    cargo install --locked --path .
  ```

### Install tmux
Repo: https://github.com/tmux/tmux/wiki/Installing

1. Install tmux (refer to docs)
      `brew install tmux`

-----------------------------------------------------