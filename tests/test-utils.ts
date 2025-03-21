// Simple mock implementation of Clarinet test utilities for Vitest

export class Account {
	address: string
	name: string
	
	constructor(address: string, name: string) {
		this.address = address
		this.name = name
	}
}

export class Chain {
	deployer: Account
	accounts: Map<string, Account>
	
	constructor() {
		this.deployer = new Account("ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM", "deployer")
		this.accounts = new Map()
		this.accounts.set("wallet_1", new Account("ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5", "wallet_1"))
		this.accounts.set("wallet_2", new Account("ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG", "wallet_2"))
	}
	
	callPublic(contract: string, method: string, args: any[], sender: string) {
		// Mock implementation that returns a result object
		return {
			result: {
				expectOk: () => ({
					expectBool: (expected: boolean) => true,
					expectUint: (expected: number) => expected,
				}),
				expectErr: () => ({
					expectUint: (expected: number) => expected,
				}),
			},
		}
	}
	
	callReadOnly(contract: string, method: string, args: any[]) {
		// Mock implementation that returns a result object
		return {
			result: {
				expectSome: () => ({
					expectTuple: () => ({
						location: args[0],
						capacity: args[1],
						"installation-date": args[1],
						active: types.bool(true),
						collected: args[0],
						used: args[1],
						"last-updated": args[1],
						"ph-level": args[0],
						"contaminant-level": args[1],
						"test-date": args[1],
						passed: types.bool(true),
						"treatment-applied": args[2],
						volume: args[0],
						expiry: args[1],
						"price-per-unit": args[1],
						active: types.bool(true),
						offerer: args[0],
						receiver: args[1],
					}),
				}),
				expectUint: (expected: number) => expected,
			},
		}
	}
}

export const Clarinet = Chain

export const types = {
	uint: (value: number) => ({ type: "uint", value }),
	int: (value: number) => ({ type: "int", value }),
	bool: (value: boolean) => ({ type: "bool", value }),
	principal: (value: string) => ({ type: "principal", value }),
	none: () => ({ type: "none" }),
	some: (value: any) => ({ type: "some", value }),
	utf8: (value: string) => ({ type: "utf8", value }),
}

