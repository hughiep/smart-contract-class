import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-ethers"
import "@nomicfoundation/hardhat-verify";

const endpointUrl = "https://sepolia.infura.io/v3/6a512e3e85bd4b7f968d1e6a243d6c3d"
const privateKey = "b2fce1c3d8d6a4c812fbf74bd472aaf9420fc701aaf46daa41408f81db6afc6b";

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: endpointUrl,
      accounts: [privateKey]
  }
  }
};

export default config;
