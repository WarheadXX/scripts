--YinYang, Good&Evil - The Time Warrior
function c10509545.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c10509545.xyzcon)
	e1:SetOperation(c10509545.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--cannot disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c10509545.effcon)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c10509545.effcon2)
	e3:SetOperation(c10509545.spsumsuc)
	c:RegisterEffect(e3)
	--atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c10509545.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetTarget(c10509545.distg)
	c:RegisterEffect(e6)
	--actlimit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,1)
	e7:SetValue(c10509545.aclimit)
	e7:SetCondition(c10509545.actcon)
	c:RegisterEffect(e7)
	--attack all
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_ATTACK_ALL)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--pierce
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e9)
	--double
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e10:SetOperation(c10509545.damop)
	c:RegisterEffect(e10)
	--Cannot be Xyz Material
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--atk/def
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_ATKCHANGE)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e12:SetCode(EVENT_BATTLE_START)
	e12:SetCondition(c10509545.adcon)
	e12:SetOperation(c10509545.adop)
	c:RegisterEffect(e12)
end

function c10509545.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end	
function c10509545.xyzfilter1(c,g,ct)
	return g:IsExists(c10509545.ovfilter,ct,c,c:GetRank())
end
function c10509545.xyzfilter2(c,rk)
	return c:GetRank()
end
function c10509545.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=math.max(2,-ft)
	local mg=Duel.GetMatchingGroup(c10509545.ovfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:IsExists(c10509545.xyzfilter1,3,nil,mg,ct)
end
function c10509545.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=math.max(2,-ft)
	local mg=Duel.GetMatchingGroup(c10509545.ovfilter,tp,LOCATION_MZONE,3,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=mg:FilterSelect(tp,c10509545.xyzfilter1,1,1,nil,mg,ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=mg:FilterSelect(tp,c10509545.xyzfilter2,ct,62,g1:GetFirst())
	g1:Merge(g2)
	local sg=Group.CreateGroup()
	local tc=g1:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end

function c10509545.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end

function c10509545.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c10509545.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c10509545.chlimit)
end
function c10509545.chlimit(e,ep,tp)
	return tp==ep
end

function c10509545.atkval(e,c)
	return c:GetOverlayCount()*1000
end

function c10509545.distg(e,c)
	return c:IsType(TYPE_XYZ)
end

function c10509545.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c10509545.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function c10509545.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end

function c10509545.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup()
end
function c10509545.adop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
	end
end