package com.sm.persistence;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.sm.domain.ClientPageVO;
import com.sm.domain.ClientsVO;

@Repository
public class ClientsDAOImpl implements ClientsDAO {
	
	// 디비 연결 정보, mapper 접근 => SqlSession 객체
	@Autowired
	private SqlSession sqlSession;
	
	private static final Logger logger = 
					LoggerFactory.getLogger(ClientsDAOImpl.class);
	
	private static final String NameSpace = "com.sm.mapper.PersonMapper";

	// 거래처 목록 불러오기
	@Override
	public List<ClientsVO> readClientsListAll(ClientPageVO cpvo) throws Exception {
		logger.debug("@@@ DAO : readClientsListAll() 호출 @@@");
		
		return sqlSession.selectList(NameSpace+".listAll", cpvo);
	}

	// 거래처 검색
	@Override
	public List<ClientsVO> getSearchClientsList(HashMap<String, Object> search) throws Exception {
		logger.debug("@@@ getSearchClientsList(HashMap<String, Object> search) 호출 @@@");
		
		return sqlSession.selectList(NameSpace+".searchClientsList", search);
	}
	
	// 거래처 전체 개수
	@Override
	public int getTotalClient() throws Exception {
		logger.debug("@@@ DAO : getTotalClient() 호출 @@@");
		
		return sqlSession.selectOne(NameSpace+".clientALLcnt");
	}
	
	// 거래처 검색 개수
	@Override
	public int getSearchClient(HashMap<String, Object> search) throws Exception {
		logger.debug("@@@ DAO : getSearchClient(HashMap<String, Object> search) 호출 @@@");
		
		return sqlSession.selectOne(NameSpace+".searchClientCnt", search);
	}

	// 거래처 추가
	@Override
	public void insertClient(ClientsVO cvo) throws Exception {
		logger.debug("@@@ DAO : insertClient(ClientPageVO cpvo) 호출 @@@");
		int result = sqlSession.insert(NameSpace+".insertClient", cvo);
		logger.debug("@@@ DAO insert 결과 : "+result);
	}
	
	// 거래처 추가 코드
	@Override
	public String getClientCode(String client_type) throws Exception {
//		String code = "L000";
		
//		if(sqlSession.selectOne(NameSpace+".getClientCode", client_type) == null) {
//			return code;
//		}else {
			return sqlSession.selectOne(NameSpace+".getClientCode", client_type);
//		}
	}

	// 거래처 삭제
	@Override
	public void deleteClient(List<String> checked) throws Exception {
		logger.debug("@@@ DAO : deleteClient(List<String> checked) 호출 @@@");
		
		Iterator<String> it = checked.iterator();
		int result = 0;
		
		while(it.hasNext()) {
			String client_code = it.next();
			result += sqlSession.delete(NameSpace+".deleteClient", client_code);
		}
		
		logger.debug("@@@ DAO delete 결과 : "+result);
	}

	// 거래처 수정
	@Override
	public void updateClient(ClientsVO cvo) throws Exception {
		logger.debug("@@@ DAO : updateClient(ClientsVO cvo) 호출 @@@");
		int result = sqlSession.update(NameSpace+".updateClient", cvo);
		logger.debug("@@@ DAO update 결과 : "+result);
	}

	
	
	
	
	
}
