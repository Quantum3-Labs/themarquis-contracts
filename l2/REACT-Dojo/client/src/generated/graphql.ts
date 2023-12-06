import { GraphQLClient } from 'graphql-request';
import { GraphQLClientRequestHeaders } from 'graphql-request/build/cjs/types';
import { print } from 'graphql'
import gql from 'graphql-tag';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
  ContractAddress: { input: any; output: any; }
  Cursor: { input: any; output: any; }
  DateTime: { input: any; output: any; }
  Enum: { input: any; output: any; }
  felt252: { input: any; output: any; }
  u32: { input: any; output: any; }
  u256: { input: any; output: any; }
};

export type Erc20Allowance = {
  __typename?: 'ERC20Allowance';
  amount?: Maybe<Scalars['u256']['output']>;
  entity?: Maybe<World__Entity>;
  owner?: Maybe<Scalars['ContractAddress']['output']>;
  spender?: Maybe<Scalars['ContractAddress']['output']>;
  token?: Maybe<Scalars['ContractAddress']['output']>;
};

export type Erc20AllowanceConnection = {
  __typename?: 'ERC20AllowanceConnection';
  edges?: Maybe<Array<Maybe<Erc20AllowanceEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type Erc20AllowanceEdge = {
  __typename?: 'ERC20AllowanceEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<Erc20Allowance>;
};

export type Erc20AllowanceOrder = {
  direction: OrderDirection;
  field: Erc20AllowanceOrderField;
};

export enum Erc20AllowanceOrderField {
  Amount = 'AMOUNT',
  Owner = 'OWNER',
  Spender = 'SPENDER',
  Token = 'TOKEN'
}

export type Erc20AllowanceWhereInput = {
  amount?: InputMaybe<Scalars['u256']['input']>;
  amountEQ?: InputMaybe<Scalars['u256']['input']>;
  amountGT?: InputMaybe<Scalars['u256']['input']>;
  amountGTE?: InputMaybe<Scalars['u256']['input']>;
  amountLT?: InputMaybe<Scalars['u256']['input']>;
  amountLTE?: InputMaybe<Scalars['u256']['input']>;
  amountNEQ?: InputMaybe<Scalars['u256']['input']>;
  owner?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  spender?: InputMaybe<Scalars['ContractAddress']['input']>;
  spenderEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  spenderGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  spenderGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  spenderLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  spenderLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  spenderNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  token?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
};

export type Erc20Balance = {
  __typename?: 'ERC20Balance';
  account?: Maybe<Scalars['ContractAddress']['output']>;
  amount?: Maybe<Scalars['u256']['output']>;
  entity?: Maybe<World__Entity>;
  token?: Maybe<Scalars['ContractAddress']['output']>;
};

export type Erc20BalanceConnection = {
  __typename?: 'ERC20BalanceConnection';
  edges?: Maybe<Array<Maybe<Erc20BalanceEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type Erc20BalanceEdge = {
  __typename?: 'ERC20BalanceEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<Erc20Balance>;
};

export type Erc20BalanceOrder = {
  direction: OrderDirection;
  field: Erc20BalanceOrderField;
};

export enum Erc20BalanceOrderField {
  Account = 'ACCOUNT',
  Amount = 'AMOUNT',
  Token = 'TOKEN'
}

export type Erc20BalanceWhereInput = {
  account?: InputMaybe<Scalars['ContractAddress']['input']>;
  accountEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  accountGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  accountGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  accountLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  accountLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  accountNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  amount?: InputMaybe<Scalars['u256']['input']>;
  amountEQ?: InputMaybe<Scalars['u256']['input']>;
  amountGT?: InputMaybe<Scalars['u256']['input']>;
  amountGTE?: InputMaybe<Scalars['u256']['input']>;
  amountLT?: InputMaybe<Scalars['u256']['input']>;
  amountLTE?: InputMaybe<Scalars['u256']['input']>;
  amountNEQ?: InputMaybe<Scalars['u256']['input']>;
  token?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
};

export type Erc20Meta = {
  __typename?: 'ERC20Meta';
  entity?: Maybe<World__Entity>;
  name?: Maybe<Scalars['felt252']['output']>;
  symbol?: Maybe<Scalars['felt252']['output']>;
  token?: Maybe<Scalars['ContractAddress']['output']>;
  total_supply?: Maybe<Scalars['u256']['output']>;
};

export type Erc20MetaConnection = {
  __typename?: 'ERC20MetaConnection';
  edges?: Maybe<Array<Maybe<Erc20MetaEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type Erc20MetaEdge = {
  __typename?: 'ERC20MetaEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<Erc20Meta>;
};

export type Erc20MetaOrder = {
  direction: OrderDirection;
  field: Erc20MetaOrderField;
};

export enum Erc20MetaOrderField {
  Name = 'NAME',
  Symbol = 'SYMBOL',
  Token = 'TOKEN',
  TotalSupply = 'TOTAL_SUPPLY'
}

export type Erc20MetaWhereInput = {
  name?: InputMaybe<Scalars['felt252']['input']>;
  nameEQ?: InputMaybe<Scalars['felt252']['input']>;
  nameGT?: InputMaybe<Scalars['felt252']['input']>;
  nameGTE?: InputMaybe<Scalars['felt252']['input']>;
  nameLT?: InputMaybe<Scalars['felt252']['input']>;
  nameLTE?: InputMaybe<Scalars['felt252']['input']>;
  nameNEQ?: InputMaybe<Scalars['felt252']['input']>;
  symbol?: InputMaybe<Scalars['felt252']['input']>;
  symbolEQ?: InputMaybe<Scalars['felt252']['input']>;
  symbolGT?: InputMaybe<Scalars['felt252']['input']>;
  symbolGTE?: InputMaybe<Scalars['felt252']['input']>;
  symbolLT?: InputMaybe<Scalars['felt252']['input']>;
  symbolLTE?: InputMaybe<Scalars['felt252']['input']>;
  symbolNEQ?: InputMaybe<Scalars['felt252']['input']>;
  token?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  tokenNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  total_supply?: InputMaybe<Scalars['u256']['input']>;
  total_supplyEQ?: InputMaybe<Scalars['u256']['input']>;
  total_supplyGT?: InputMaybe<Scalars['u256']['input']>;
  total_supplyGTE?: InputMaybe<Scalars['u256']['input']>;
  total_supplyLT?: InputMaybe<Scalars['u256']['input']>;
  total_supplyLTE?: InputMaybe<Scalars['u256']['input']>;
  total_supplyNEQ?: InputMaybe<Scalars['u256']['input']>;
};

export type Game = {
  __typename?: 'Game';
  entity?: Maybe<World__Entity>;
  game_id?: Maybe<Scalars['u32']['output']>;
  last_total_paid?: Maybe<Scalars['u32']['output']>;
  move_count?: Maybe<Scalars['u32']['output']>;
};

export type GameConnection = {
  __typename?: 'GameConnection';
  edges?: Maybe<Array<Maybe<GameEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type GameEdge = {
  __typename?: 'GameEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<Game>;
};

export type GameOrder = {
  direction: OrderDirection;
  field: GameOrderField;
};

export enum GameOrderField {
  GameId = 'GAME_ID',
  LastTotalPaid = 'LAST_TOTAL_PAID',
  MoveCount = 'MOVE_COUNT'
}

export type GameWhereInput = {
  game_id?: InputMaybe<Scalars['u32']['input']>;
  game_idEQ?: InputMaybe<Scalars['u32']['input']>;
  game_idGT?: InputMaybe<Scalars['u32']['input']>;
  game_idGTE?: InputMaybe<Scalars['u32']['input']>;
  game_idLT?: InputMaybe<Scalars['u32']['input']>;
  game_idLTE?: InputMaybe<Scalars['u32']['input']>;
  game_idNEQ?: InputMaybe<Scalars['u32']['input']>;
  last_total_paid?: InputMaybe<Scalars['u32']['input']>;
  last_total_paidEQ?: InputMaybe<Scalars['u32']['input']>;
  last_total_paidGT?: InputMaybe<Scalars['u32']['input']>;
  last_total_paidGTE?: InputMaybe<Scalars['u32']['input']>;
  last_total_paidLT?: InputMaybe<Scalars['u32']['input']>;
  last_total_paidLTE?: InputMaybe<Scalars['u32']['input']>;
  last_total_paidNEQ?: InputMaybe<Scalars['u32']['input']>;
  move_count?: InputMaybe<Scalars['u32']['input']>;
  move_countEQ?: InputMaybe<Scalars['u32']['input']>;
  move_countGT?: InputMaybe<Scalars['u32']['input']>;
  move_countGTE?: InputMaybe<Scalars['u32']['input']>;
  move_countLT?: InputMaybe<Scalars['u32']['input']>;
  move_countLTE?: InputMaybe<Scalars['u32']['input']>;
  move_countNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type ModelUnion = Erc20Allowance | Erc20Balance | Erc20Meta | Game | Move | WorldHelperStorage;

export type Move = {
  __typename?: 'Move';
  amount?: Maybe<Scalars['u32']['output']>;
  choice?: Maybe<Scalars['Enum']['output']>;
  entity?: Maybe<World__Entity>;
  game_id?: Maybe<Scalars['u32']['output']>;
  move_id?: Maybe<Scalars['u32']['output']>;
  player?: Maybe<Scalars['ContractAddress']['output']>;
};

export type MoveConnection = {
  __typename?: 'MoveConnection';
  edges?: Maybe<Array<Maybe<MoveEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type MoveEdge = {
  __typename?: 'MoveEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<Move>;
};

export type MoveOrder = {
  direction: OrderDirection;
  field: MoveOrderField;
};

export enum MoveOrderField {
  Amount = 'AMOUNT',
  Choice = 'CHOICE',
  GameId = 'GAME_ID',
  MoveId = 'MOVE_ID',
  Player = 'PLAYER'
}

export type MoveWhereInput = {
  amount?: InputMaybe<Scalars['u32']['input']>;
  amountEQ?: InputMaybe<Scalars['u32']['input']>;
  amountGT?: InputMaybe<Scalars['u32']['input']>;
  amountGTE?: InputMaybe<Scalars['u32']['input']>;
  amountLT?: InputMaybe<Scalars['u32']['input']>;
  amountLTE?: InputMaybe<Scalars['u32']['input']>;
  amountNEQ?: InputMaybe<Scalars['u32']['input']>;
  choice?: InputMaybe<Scalars['Enum']['input']>;
  game_id?: InputMaybe<Scalars['u32']['input']>;
  game_idEQ?: InputMaybe<Scalars['u32']['input']>;
  game_idGT?: InputMaybe<Scalars['u32']['input']>;
  game_idGTE?: InputMaybe<Scalars['u32']['input']>;
  game_idLT?: InputMaybe<Scalars['u32']['input']>;
  game_idLTE?: InputMaybe<Scalars['u32']['input']>;
  game_idNEQ?: InputMaybe<Scalars['u32']['input']>;
  move_id?: InputMaybe<Scalars['u32']['input']>;
  move_idEQ?: InputMaybe<Scalars['u32']['input']>;
  move_idGT?: InputMaybe<Scalars['u32']['input']>;
  move_idGTE?: InputMaybe<Scalars['u32']['input']>;
  move_idLT?: InputMaybe<Scalars['u32']['input']>;
  move_idLTE?: InputMaybe<Scalars['u32']['input']>;
  move_idNEQ?: InputMaybe<Scalars['u32']['input']>;
  player?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
};

export enum OrderDirection {
  Asc = 'ASC',
  Desc = 'DESC'
}

export type WorldHelperStorage = {
  __typename?: 'WorldHelperStorage';
  entity?: Maybe<World__Entity>;
  owner?: Maybe<Scalars['ContractAddress']['output']>;
  usd_m_address?: Maybe<Scalars['ContractAddress']['output']>;
  world?: Maybe<Scalars['ContractAddress']['output']>;
};

export type WorldHelperStorageConnection = {
  __typename?: 'WorldHelperStorageConnection';
  edges?: Maybe<Array<Maybe<WorldHelperStorageEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type WorldHelperStorageEdge = {
  __typename?: 'WorldHelperStorageEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<WorldHelperStorage>;
};

export type WorldHelperStorageOrder = {
  direction: OrderDirection;
  field: WorldHelperStorageOrderField;
};

export enum WorldHelperStorageOrderField {
  Owner = 'OWNER',
  UsdMAddress = 'USD_M_ADDRESS',
  World = 'WORLD'
}

export type WorldHelperStorageWhereInput = {
  owner?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  usd_m_address?: InputMaybe<Scalars['ContractAddress']['input']>;
  usd_m_addressEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  usd_m_addressGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  usd_m_addressGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  usd_m_addressLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  usd_m_addressLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  usd_m_addressNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  world?: InputMaybe<Scalars['ContractAddress']['input']>;
  worldEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  worldGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  worldGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  worldLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  worldLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  worldNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
};

export type World__Content = {
  __typename?: 'World__Content';
  cover_uri?: Maybe<Scalars['String']['output']>;
  description?: Maybe<Scalars['String']['output']>;
  icon_uri?: Maybe<Scalars['String']['output']>;
  name?: Maybe<Scalars['String']['output']>;
  socials?: Maybe<Array<Maybe<World__Social>>>;
  website?: Maybe<Scalars['String']['output']>;
};

export type World__Entity = {
  __typename?: 'World__Entity';
  created_at?: Maybe<Scalars['DateTime']['output']>;
  event_id?: Maybe<Scalars['String']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  keys?: Maybe<Array<Maybe<Scalars['String']['output']>>>;
  model_names?: Maybe<Scalars['String']['output']>;
  models?: Maybe<Array<Maybe<ModelUnion>>>;
  updated_at?: Maybe<Scalars['DateTime']['output']>;
};

export type World__EntityConnection = {
  __typename?: 'World__EntityConnection';
  edges?: Maybe<Array<Maybe<World__EntityEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type World__EntityEdge = {
  __typename?: 'World__EntityEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Entity>;
};

export type World__Event = {
  __typename?: 'World__Event';
  created_at?: Maybe<Scalars['DateTime']['output']>;
  data?: Maybe<Array<Maybe<Scalars['String']['output']>>>;
  id?: Maybe<Scalars['ID']['output']>;
  keys?: Maybe<Array<Maybe<Scalars['String']['output']>>>;
  transaction_hash?: Maybe<Scalars['String']['output']>;
};

export type World__EventConnection = {
  __typename?: 'World__EventConnection';
  edges?: Maybe<Array<Maybe<World__EventEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type World__EventEdge = {
  __typename?: 'World__EventEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Event>;
};

export type World__Metadata = {
  __typename?: 'World__Metadata';
  content?: Maybe<World__Content>;
  cover_img?: Maybe<Scalars['String']['output']>;
  created_at?: Maybe<Scalars['DateTime']['output']>;
  icon_img?: Maybe<Scalars['String']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  updated_at?: Maybe<Scalars['DateTime']['output']>;
  uri?: Maybe<Scalars['String']['output']>;
};

export type World__MetadataConnection = {
  __typename?: 'World__MetadataConnection';
  edges?: Maybe<Array<Maybe<World__MetadataEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type World__MetadataEdge = {
  __typename?: 'World__MetadataEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Metadata>;
};

export type World__Model = {
  __typename?: 'World__Model';
  class_hash?: Maybe<Scalars['felt252']['output']>;
  created_at?: Maybe<Scalars['DateTime']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  name?: Maybe<Scalars['String']['output']>;
  transaction_hash?: Maybe<Scalars['felt252']['output']>;
};

export type World__ModelConnection = {
  __typename?: 'World__ModelConnection';
  edges?: Maybe<Array<Maybe<World__ModelEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type World__ModelEdge = {
  __typename?: 'World__ModelEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Model>;
};

export type World__Query = {
  __typename?: 'World__Query';
  entities?: Maybe<World__EntityConnection>;
  entity: World__Entity;
  erc20allowanceModels?: Maybe<Erc20AllowanceConnection>;
  erc20balanceModels?: Maybe<Erc20BalanceConnection>;
  erc20metaModels?: Maybe<Erc20MetaConnection>;
  events?: Maybe<World__EventConnection>;
  gameModels?: Maybe<GameConnection>;
  metadatas?: Maybe<World__MetadataConnection>;
  model: World__Model;
  models?: Maybe<World__ModelConnection>;
  moveModels?: Maybe<MoveConnection>;
  transaction: World__Transaction;
  transactions?: Maybe<World__TransactionConnection>;
  worldhelperstorageModels?: Maybe<WorldHelperStorageConnection>;
};


export type World__QueryEntitiesArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  keys?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type World__QueryEntityArgs = {
  id: Scalars['ID']['input'];
};


export type World__QueryErc20allowanceModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<Erc20AllowanceOrder>;
  where?: InputMaybe<Erc20AllowanceWhereInput>;
};


export type World__QueryErc20balanceModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<Erc20BalanceOrder>;
  where?: InputMaybe<Erc20BalanceWhereInput>;
};


export type World__QueryErc20metaModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<Erc20MetaOrder>;
  where?: InputMaybe<Erc20MetaWhereInput>;
};


export type World__QueryEventsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  keys?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type World__QueryGameModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<GameOrder>;
  where?: InputMaybe<GameWhereInput>;
};


export type World__QueryMetadatasArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type World__QueryModelArgs = {
  id: Scalars['ID']['input'];
};


export type World__QueryModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type World__QueryMoveModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<MoveOrder>;
  where?: InputMaybe<MoveWhereInput>;
};


export type World__QueryTransactionArgs = {
  id: Scalars['ID']['input'];
};


export type World__QueryTransactionsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type World__QueryWorldhelperstorageModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<WorldHelperStorageOrder>;
  where?: InputMaybe<WorldHelperStorageWhereInput>;
};

export type World__Social = {
  __typename?: 'World__Social';
  name?: Maybe<Scalars['String']['output']>;
  url?: Maybe<Scalars['String']['output']>;
};

export type World__Subscription = {
  __typename?: 'World__Subscription';
  entityUpdated: World__Entity;
  modelRegistered: World__Model;
};


export type World__SubscriptionEntityUpdatedArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
};


export type World__SubscriptionModelRegisteredArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
};

export type World__Transaction = {
  __typename?: 'World__Transaction';
  calldata?: Maybe<Array<Maybe<Scalars['felt252']['output']>>>;
  created_at?: Maybe<Scalars['DateTime']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  max_fee?: Maybe<Scalars['felt252']['output']>;
  nonce?: Maybe<Scalars['felt252']['output']>;
  sender_address?: Maybe<Scalars['felt252']['output']>;
  signature?: Maybe<Array<Maybe<Scalars['felt252']['output']>>>;
  transaction_hash?: Maybe<Scalars['felt252']['output']>;
};

export type World__TransactionConnection = {
  __typename?: 'World__TransactionConnection';
  edges?: Maybe<Array<Maybe<World__TransactionEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type World__TransactionEdge = {
  __typename?: 'World__TransactionEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Transaction>;
};

export type GetEntitiesQueryVariables = Exact<{ [key: string]: never; }>;


export type GetEntitiesQuery = { __typename?: 'World__Query', entities?: { __typename?: 'World__EntityConnection', edges?: Array<{ __typename?: 'World__EntityEdge', node?: { __typename?: 'World__Entity', keys?: Array<string | null> | null, models?: Array<{ __typename: 'ERC20Allowance' } | { __typename: 'ERC20Balance', account?: any | null, amount?: any | null } | { __typename: 'ERC20Meta' } | { __typename: 'Game' } | { __typename: 'Move' } | { __typename: 'WorldHelperStorage' } | null> | null } | null } | null> | null } | null };


export const GetEntitiesDocument = gql`
    query getEntities {
  entities(keys: ["*"]) {
    edges {
      node {
        keys
        models {
          __typename
          ... on ERC20Balance {
            account
            amount
          }
        }
      }
    }
  }
}
    `;

export type SdkFunctionWrapper = <T>(action: (requestHeaders?:Record<string, string>) => Promise<T>, operationName: string, operationType?: string) => Promise<T>;


const defaultWrapper: SdkFunctionWrapper = (action, _operationName, _operationType) => action();
const GetEntitiesDocumentString = print(GetEntitiesDocument);
export function getSdk(client: GraphQLClient, withWrapper: SdkFunctionWrapper = defaultWrapper) {
  return {
    getEntities(variables?: GetEntitiesQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<{ data: GetEntitiesQuery; extensions?: any; headers: Dom.Headers; status: number; }> {
        return withWrapper((wrappedRequestHeaders) => client.rawRequest<GetEntitiesQuery>(GetEntitiesDocumentString, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getEntities', 'query');
    }
  };
}
export type Sdk = ReturnType<typeof getSdk>;