��̨׼������
@Transactional
	@DataProvider
	public void getData1(Page<ʵ����> page){
		dao.find(page, "from EmTeam where teamtype='Ӧ���쵼С��' order by ordernum");
	}

ǰ̨׼���ؼ�data