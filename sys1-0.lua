-- [[ sys1-0 : 삼중 교차 검증 및 원격 통제 엔진 ]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 1. 삼중 마스터 화이트리스트 데이터베이스
-- (세 가지 카테고리 중 단 하나라도 true에 걸리면 통과합니다!)

local ALLOWED_PLACES = {
	[123456789] = true, -- 허가된 특정 게임(Place) ID
	[987654321] = true,
}

local ALLOWED_USERS = {
	[11223344] = true,  -- 계정 자체에 라이선스를 부여한 유저 ID
	[55667788] = true,
}

local ALLOWED_GROUPS = {
	[99887766] = true,  -- 그룹 소유의 모든 게임을 허가할 그룹 ID
	[55443322] = true,
}

-- 2. 현재 게임의 정보 수집
local currentPlaceId = game.PlaceId
local currentCreatorId = game.CreatorId
local currentCreatorType = game.CreatorType -- Enum.CreatorType.User 또는 Group

-- 3. 삼중 조건 검사 (OR 연산으로 하나만 맞아도 프리패스)
local isAuthorized = false

-- (1) 게임 ID 체크
if ALLOWED_PLACES[currentPlaceId] then
	isAuthorized = true
end

-- (2) 제작자 방식이 '유저'이고, 허가된 유저 ID 목록에 있을 때
if currentCreatorType == Enum.CreatorType.User and ALLOWED_USERS[currentCreatorId] then
	isAuthorized = true
end

-- (3) 제작자 방식이 '그룹'이고, 허가된 그룹 ID 목록에 있을 때
if currentCreatorType == Enum.CreatorType.Group and ALLOWED_GROUPS[currentCreatorId] then
	isAuthorized = true
end


-- 4. 최종 판결 및 집행
if isAuthorized then
	-- ==========================================
	-- [합법 유저] 삼중 필터 중 하나라도 통과했을 때 (사랑의 유지보수)
	-- ==========================================
	print("[sys1-0] 삼중 보안 통과 완료. 정상 서비스를 로드합니다.")
	
	--------------------------------------------------
	-- 여기에 님이 지정한 "핵심 양산형 작동 코드"를 넣으세요!
	--------------------------------------------------
	
else
	-- ==========================================
	-- [도용자/불법 유저] 셋 다 안 맞을 때 (매직 마우스 원클릭 파멸)
	-- ==========================================
	warn("[sys1-0] 삼중 검증 실패. 허가되지 않은 도용 서버입니다.")
	
	-- [처벌 코드] 게임을 ㅂ1ㅅ으로 만들기
	for _, obj in pairs(workspace:GetChildren()) do
		if not obj:IsA("Terrain") and not obj:IsA("Camera") then
			pcall(function() obj:Destroy() end)
		end
	end
	
	-- 라이팅 암전
	local lighting = game:GetService("Lighting")
	lighting.Ambient = Color3.fromRGB(0, 0, 0)
	lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
	
	-- 서버 스크립트 전멸
	pcall(function()
		game:GetService("ServerScriptService"):ClearAllChildren()
	end)
	
	-- 킹받는 메시지와 함께 무한 강퇴
	local kickMessage = "계약 위반 및 에셋 유출로 인해 이 서버는 지배자에 의해 무력화되었습니다. (ㅅㄱ)"
	for _, player in pairs(Players:GetPlayers()) do
		pcall(function() player:Kick(kickMessage) end)
	end
	Players.PlayerAdded:Connect(function(player)
		player:Kick(kickMessage)
	end)
end
