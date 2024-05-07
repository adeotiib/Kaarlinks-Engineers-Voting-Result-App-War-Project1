package com.jendareyconsulting.votingresultapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@SpringBootApplication
@Controller
public class VotingResultAppApplication {

    private List<StudentVote> studentVotes = new ArrayList<>();
    private Map<Course, Integer> courseVotes = new HashMap<>();

    @GetMapping("/")
    public String index(Model model) {
        try {
            InetAddress localHost = InetAddress.getLocalHost();
            String hostname = localHost.getHostName();
            String ipAddress = localHost.getHostAddress();

            model.addAttribute("title", "Kaarlinks DevOps Bootcamp Training");
            model.addAttribute("hostname", "Hostname: " + hostname);
            model.addAttribute("ipAddress", "IP Address: " + ipAddress);
            model.addAttribute("courses", Course.values());
            model.addAttribute("studentVotes", studentVotes);

            // Get the top 4 courses by vote count
            List<CourseVote> topCourses = courseVotes.entrySet()
                    .stream()
                    .map(entry -> new CourseVote(entry.getKey(), entry.getValue()))
                    .sorted((c1, c2) -> Integer.compare(c2.getVoteCount(), c1.getVoteCount()))
                    .limit(4)
                    .collect(Collectors.toList());

            model.addAttribute("topCourses", topCourses);

        } catch (UnknownHostException e) {
            e.printStackTrace();
        }

        return "index";
    }

    @PostMapping("/submit")
    public String submitVote(@RequestParam("firstName") String firstName,
                             @RequestParam("lastName") String lastName,
                             @RequestParam("email") String email,
                             @RequestParam("course") Course course) {
        StudentVote studentVote = new StudentVote(firstName, lastName, email, course);
        studentVotes.add(studentVote);

        int currentVoteCount = courseVotes.getOrDefault(course, 0);
        courseVotes.put(course, currentVoteCount + 1);

        return "redirect:/";
    }

	public static void main(String[] args) {
		SpringApplication.run(VotingResultAppApplication.class, args);
	}

}
