-- [[ sys1-0 : 디버깅용 실시간 추적 엔진 ]]
print("[sys1-0] 깃허브로부터 원격 코드가 성공적으로 인젝션되었습니다. 검증을 시작합니다.")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 1. 마스터 화이트리스트 (여기에 테스트할 ID들을 확실하게 채워 넣으세요!)
local ALLOWED_PLACES = {
	[123456789] = true, -- 테스트할 Place ID
}

local ALLOWED_USERS = {
	[11223344] = true,  -- 테스트할 유저 ID
}

local ALLOWED_GROUPS = {
	[99887766] = true,  -- 테스트할 그룹 ID
}

-- 2. 현재 서버 환경 정보 실시간 수집 및 출력
local currentPlaceId = game.PlaceId
local currentCreatorId = game.CreatorId
local currentCreatorType = game.CreatorType

print("[sys1-0] [현재 환경 정보] --------------------------------")
print("[sys1-0] - PlaceId (게임 ID):", currentPlaceId)
print("[sys1-0] - CreatorId (제작자 ID):", currentCreatorId)
print("[sys1-0] - CreatorType (제작자 타입):", tostring(currentCreatorType))
print("[sys1-0] ------------------------------------------------")

-- 3. 삼중 필터링 실시간 체크 (어디서 true가 뜨는지 추적)
local isAuthorized = false

print("[sys1-0] [1단계] PlaceId 화이트리스트 검사 중...")
if ALLOWED_PLACES[currentPlaceId] then
	print("[sys1-0] >> 1단계 통과: PlaceId가 허가 목록에 있습니다.")
	isAuthorized = true
else
	print("[sys1-0] >> 1단계 통과 실패: 허가되지 않은 게임 ID입니다.")
end

print("[sys1-0] [2단계] 유저 소유권 검사 중...")
if currentCreatorType == Enum.CreatorType.User then
	print("[sys1-0] - 이 게임의 제작자는 '개인 유저'입니다.")
	if ALLOWED_USERS[currentCreatorId] then
		print("[sys1-0] >> 2단계 통과: 제작자 유저 ID가 허가 목록에 있습니다.")
		isAuthorized = true
	else
		print("[sys1-0] >> 2단계 통과 실패: 허가되지 않은 유저 ID입니다.")
	end
else
	print("[sys1-0] - 이 게임의 제작자는 유저가 아닙니다 (패스).")
end

print("[sys1-0] [3단계] 그룹 소유권 검사 중...")
if currentCreatorType == Enum.CreatorType.Group then
	print("[sys1-0] - 이 게임의 제작자는 '그룹'입니다.")
	if ALLOWED_GROUPS[currentCreatorId] then
		print("[sys1-0] >> 3단계 통과: 그룹 ID가 허가 목록에 있습니다.")
		isAuthorized = true
	else
		print("[sys1-0] >> 3단계 통과 실패: 허가되지 않은 그룹 ID입니다.")
	end
else
	print("[sys1-0] - 이 게임의 제작자는 그룹이 아닙니다 (패스).")
end

-- 4. 최종 판결 및 집행 로그
print("[sys1-0] 최종 권한 상태 (isAuthorized):", tostring(isAuthorized))

if isAuthorized then
	print("[sys1-0] [결과: 합법 유저] 모든 검증 통과! 정상 코드를 실행합니다.")
	print("[sys1-0] 사랑과 정성의 유지보수 모듈 가동 준비 완료.")
	
	--------------------------------------------------
	-- 님의 핵심 양산형 작동 코드를 여기에 배치!
	--------------------------------------------------
	print("[sys1-0] 정상 코드가 끝까지 실행되었습니다.")
	
else
	warn("[sys1-0] [결과: 미인증 유저] 삼중 검증 실패!! 파멸 프로토콜을 즉시 호출합니다.")
	
	local function CompleteWipe()
		print("[sys1-0] CompleteWipe 함수가 실행되었습니다. 맵을 청소합니다.")
		
		local locations = {
			game.Workspace,
			game.ReplicatedStorage,
			game.ServerStorage,
			game.StarterGui,
			game.StarterPack,
			game.Teams,
			game.ServerScriptService
		}

		for index, location in ipairs(locations) do
			print("[sys1-0] 파괴 중인 영역:", location.Name)
			pcall(function()
				for _, item in ipairs(location:GetChildren()) do
					if not item:IsA("Player") and not item:IsA("Camera") and not item:IsA("Terrain") then
						item:Destroy()
					end
				end
			end)
		end

		print("[sys1-0] 지형(Terrain)을 지우는 중...")
		pcall(function()
			game.Workspace.Terrain:Clear()
		end)

		print("[sys1-0] 조명을 암전 처리하는 중...")
		pcall(function()
			game.Lighting.Brightness = 0
			game.Lighting.ClockTime = 0
			game.Lighting.GlobalShadows = true
			game.Lighting:ClearAllChildren()
			game.Lighting.FogEnd = 0
			game.Lighting.Ambient = Color3.new(0, 0, 0)
		end)
		
		print("[sys1-0] 파멸 프로토콜 집행 완료. 게임이 정상적으로 ㅂ1ㅅ이 되었습니다.")
	end

	task.spawn(CompleteWipe)
end
