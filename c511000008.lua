--Hook the Hidden Knight
function c511000008.initial_effect(c)
	--Change Battle Position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000008,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetTarget(c511000008.target)
	e1:SetOperation(c511000008.operation)
	c:RegisterEffect(e1)
	--Inflict Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000008,1))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCondition(c511000008.condition)
	e2:SetTarget(c511000008.damtg)
	e2:SetOperation(c511000008.damop)
	c:RegisterEffect(e2)
end
function c511000008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local c=e:GetHandler()
	local bc=Duel.GetAttacker()
	if chk==0 then return bc and bc:IsOnField() and bc:IsCanBeEffectTarget(e) and c:IsAttackPos() and bc:IsAttackPos() end
	Duel.SetTargetCard(bc)
	local g=Group.FromCards(c,bc)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,2,0,0)
end
function c511000008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
function c511000008.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousPosition(),POS_ATTACK)~=0 and c:IsFaceup() and c:IsDefensePos()
end
function c511000008.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c511000008.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
