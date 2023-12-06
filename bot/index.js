import cron from "node-cron";
import {
  initializeUsdMToken,
  intializeTheMarquis,
  theMarquisActionsAddress,
  mintUsdM,
  openBets,
  placeRandomBet,
  spawn,
  gameId,
  gameDuration,
  waitForSpinTime,
  setWinner,
  spinningDuration,
  sleep,
  closeBets,
  masterAccount,
  printUSDmBalance,
  hexToAscii,
} from "./utils/utils.js";

async function spinWheel() {
  console.log("spinning wheel");
}

async function mainSetup() {
  await intializeTheMarquis();
  await initializeUsdMToken();
  await spawn();
  await mintUsdM(10000000 * 10 ** 3);
  await mintUsdM(1000000000 * 10 ** 3, theMarquisActionsAddress);
  console.log("game id");
  console.log(gameId);
}

mainSetup()
  .then(() => {
    console.log("All Setup Done");
  })
  .catch(console.error);

// async function initNewGame() {
//   printUSDmBalance(theMarquisActionsAddress).then();
//   // open bets
//   openBets().then();

//   // perform subsequent bets
//   let leftTime = gameDuration;
//   while (leftTime > 0) {
//     const randomNumber = Math.floor(Math.random() * (leftTime / 20 - 2)) + 1500;
//     placeRandomBet().then();
//     if (randomNumber < leftTime) await sleep(randomNumber);
//     leftTime -= randomNumber;
//   }

//   closeBets().then();
//   // wait for game to end
//   await sleep(-leftTime);
//   // spin the wheel
//   await sleep(waitForSpinTime);
//   spinWheel().then();
//   // wait for spinning
//   await sleep(spinningDuration);

//   // set winner
//   setWinner().then(() => {
//     printUSDmBalance(theMarquisActionsAddress).then();
//   });
// }

// cron.schedule("*/2 * * * *", initNewGame);
