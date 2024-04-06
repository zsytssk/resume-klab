- 一秒改变一次

```lua
if fCount >= 1000 then
		fCount = fCount - 1000
		local score = sysCommand(pSCORE, UI_SCORE_GET)
		score = score + 1
		sysCommand(pSCORE, UI_SCORE_SET, score)
	end
```
