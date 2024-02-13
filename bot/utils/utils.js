import { Account, RpcProvider, shortString, Contract } from "starknet";
import dotenv from "dotenv";

dotenv.config();

const masterAddress = process.env.MASTER_ADDRESS;
const privateKey = process.env.MASTER_PRIVATE_KEY;
const nodeUrl = process.env.RPC_PROVIDER;
export const theMarquisActionsAddress = process.env.THE_MARQUIS_ACTIONS_ADDRESS;
const usdMTokenAddress = process.env.USD_M_TOKEN_ADDRESS;
export const worldAddress = process.env.WORLD_ADDRESS;
const tokenName = shortString.encodeShortString(process.env.TOKEN_NAME);
const tokenSymbol = shortString.encodeShortString(process.env.TOKEN_SYMBOL);
const rpcProvider = new RpcProvider({ nodeUrl });
export const masterAccount = new Account(
  rpcProvider,
  masterAddress,
  privateKey
);

export let gameDuration = 45 * 1000; // 45 seconds
export let waitForSpinTime = 15 * 1000; // 15 seconds
export let spinningDuration = 15 * 1000; // 15 seconds
export let nextPlayWaitTime = 10 * 1000; // 10 seconds
export let gameId = 0;

const executeTransaction = async (
  toAddress,
  functionName,
  calldata,
  customError,
  customAccount
) => {
  let thisAccount = masterAccount;
  if (customAccount) {
    thisAccount = customAccount;
  }
  const nonce = await thisAccount?.getNonce();

  // execute a function
  const tx = await thisAccount.execute(
    [{
      contractAddress: toAddress,
      entrypoint: functionName,
      calldata: calldata,
    }],
    undefined,
    {
      maxFee: 0,
      nonce,
    }
  );

  const receipt = await thisAccount.waitForTransaction(tx.transaction_hash, {
    retryInterval: 100,
  });
  if (receipt.execution_status !== "SUCCEEDED") {
    throw new Error(customError);
  }
  return receipt;
};

export const intializeTheMarquis = async () => {
  await executeTransaction(
    theMarquisActionsAddress,
    "initialize",
    [usdMTokenAddress],
    "Failed to initialize the marquis"
  );
};

export const initializeUsdMToken = async () => {
  await executeTransaction(
    usdMTokenAddress,
    "initialize",
    [tokenName, tokenSymbol, worldAddress],
    "Failed to initialize USD M Token"
  );
};

export const mintUsdM = async (amount, to) => {
  await executeTransaction(
    usdMTokenAddress,
    "mint_",
    [to ? to : masterAccount.address, amount, 0],
    "Failed to mint USD M Token"
  );
};

export const openBets = async () => {
  // TODO : add function in contract to open bets
  console.log("opening bets");
};

export const closeBets = async () => {
  console.log("closing bets bets");
};

export const placeRandomBet = async () => {
  // get 3 random number from 1 to 48
  const randomNumber1 = Math.floor(Math.random() * 48) + 1;
  const randomNumber2 = Math.floor(Math.random() * 48) + 1;
  const randomNumber3 = Math.floor(Math.random() * 48) + 1;

  // get 3 random amounts from 1 to 100 multiple of 10
  const randomAmount1 = (Math.floor(Math.random() * 10) + 1) * 10 * 10 ** 3;
  const randomAmount2 = (Math.floor(Math.random() * 10) + 1) * 10 * 10 ** 3;
  const randomAmount3 = (Math.floor(Math.random() * 10) + 1) * 10 * 10 ** 3;

  // approce tokens first
  await executeTransaction(
    usdMTokenAddress,
    "approve",
    [
      theMarquisActionsAddress,
      randomAmount1 + randomAmount2 + randomAmount3,
      0,
    ],
    "Failed to approve tokens"
  );

  await executeTransaction(
    theMarquisActionsAddress,
    "move",
    [
      gameId,
      3,
      randomNumber1,
      randomNumber2,
      randomNumber3,
      3,
      randomAmount1,
      randomAmount2,
      randomAmount3,
    ],
    "Failed to place bet"
  );
};

export const spawn = async () => {
  const txReceipt = await executeTransaction(
    theMarquisActionsAddress,
    "spawn",
    [],
    "Failed to spawn"
  );
  gameId = txReceipt.events[txReceipt.events.length - 1].keys[1];
};
export const setWinner = async () => {
  const randomNumber = Math.floor(Math.random() * 36);
  await executeTransaction(
    theMarquisActionsAddress,
    "set_winner",
    [gameId, 3],
    "Failed to set winner"
  );
  console.log("winner number is", 3);
};
export function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export function hexToAscii(hex) {
  var str = "";
  for (var n = 2; n < hex.length; n += 2) {
    str += String.fromCharCode(parseInt(hex.substr(n, 2), 16));
  }
  return str;
}

export async function printUSDmBalance(account) {
  const { abi: usdMTokenAbi } = await rpcProvider.getClassAt(usdMTokenAddress);
  const cUSDm = new Contract(usdMTokenAbi, usdMTokenAddress, rpcProvider);
  const balance = await cUSDm.balanceOf(account);
  console.log("USD M balance of", account, "is", balance);
}
