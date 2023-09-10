package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Career;
import ar.edu.itba.paw.persistence.CareerDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CareerServiceImpl implements CareerService {
    private final CareerDao careerDao;

    @Autowired
    public CareerServiceImpl(final CareerDao careerDao){
        this.careerDao = careerDao;
    }


    @Override
    public List<Career> getCareers() {
        return careerDao.getCareers();
    }
}