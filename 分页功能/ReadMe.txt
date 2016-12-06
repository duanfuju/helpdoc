后台准备数据
@Transactional
	@DataProvider
	public void getData1(Page<实体类> page){
		dao.find(page, "from EmTeam where teamtype='应急领导小组' order by ordernum");
	}

前台准备控件data