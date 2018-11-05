--[[
这脚本就单纯上下滚动页面，不会有鼠标跳来跳去和产生额外的动作，单纯看电子书和浏览页面最合适不过
Myo的lua脚本文档
https://developer.thalmic.com/docs/api_reference/platform/script-reference.html#script-api-vibrate
--]]

scriptId = 'com.scifx.MouseScroll'--Id喜欢就行，但格式要对
scriptTitle = "页面滑动"--脚本的显示标题
scriptDetailsUrl = "scifx.github.io"--脚本详情页
Platform="Windows"--系统

turn=0--激活状态
num=0--计数器
state=1--滑动偏移量（向滑和下滑分别是1和-1）


function onPoseEdge(pose, edge)--姿势侦听器
	if(pose~="rest" and edge=="on")then--一般动作都以rest，off开始
		turn=1
		myo.unlock('hold')--'hold'为保持解锁
		if (pose=="waveOut")then--手势向外
			state=1
		elseif(pose=="waveIn")then--手势向内
			state=-1
		end
	else
		turn=0
		num=0
		myo.unlock('timed')--'timed'为定时锁定
	end
end
--[[
侦听到动作时
如果当前动作是rest以外的（rest是无姿势所以得排除掉），并且是激活状态
	开锁
	检查手势是向内还是向外，分别设置为1和-1的滑动偏移量
其他情况
	重置状态和计数器并且锁定
--]]


function onPeriodic()--间断执行器，每隔10毫秒执行一次
	if (turn==1)then
		num=num+1
		if(num%10==0)then
			myo.mouseScrollBy(state)--鼠标滑动
		end
	end
end
--[[
每隔10毫秒执行
	如果激活状态是1，那么计数器+1
	如果当前计数器能被10除尽，那就滑动鼠标（state是滑动的量，+1就上滑，-1就下滑）
--]]

function onForegroundWindowChange(app, title)--当前置窗口改变时
    return true
end

function activeAppName()--激活的应用名称，随便就行
    return "Output Everything"
end

function onActiveChange(isActive)--当开启这个脚本的时候
	myo.vibrate("short")--震动，另外还有中震动和长震动分别是"medium"和"long".
end