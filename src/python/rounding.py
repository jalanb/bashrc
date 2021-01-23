shop_rounding = lambda x: 2 - ((x + 2) % 5)

def fred(items, n, k):
    if not k:
        return sum(items)
    if not items:
        return 0
    i, total, round_total = 0, 0, -999
    item, *items = items
    total = item
    round_total = shop_rounding(total)
    while items:
        item, *items = items
        total += item
        round_total = shop_rounding(total)
        if round_total == 0:
            continue
        elif round_total < 0:
            continue
        elif round_total > 0:
            break
        i += 1
    fred_total = fred(items, len(items), k - 1)
    return round_total + fred_total

fred([1,1, 1,1, 1,1,], 6, 2)
