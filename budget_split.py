#!/usr/bin/env python3
"""Split income using the 50/30/20 budget rule."""

import argparse


def budget_split(amount):
    needs = amount * 0.50
    wants = amount * 0.30
    savings = amount * 0.20
    return needs, wants, savings


def main():
    parser = argparse.ArgumentParser(description="Split income using the 50/30/20 rule")
    parser.add_argument("income", type=float, help="total income to split")
    args = parser.parse_args()

    if args.income <= 0:
        parser.error("income must be positive")

    needs, wants, savings = budget_split(args.income)

    print(f"Needs   (50%): {needs:.2f}")
    print(f"Wants   (30%): {wants:.2f}")
    print(f"Savings (20%): {savings:.2f}")


if __name__ == "__main__":
    main()