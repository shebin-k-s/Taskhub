import Project from "../models/project.js";
import Skill from "../models/skills.js";
import Work from "../models/work.js";

export const addProject = async (req, res) => {
    const { pName, skills, startDate, endDate, durations } = req.body;
    const formattedStartDate = new Date(startDate);
    const formattedEndDate = new Date(endDate);

    try {
console.log(skills.length);
        // const skillsArray = skills.split(',');
        // console.log(skillsArray.length);
        // const durationArray = durations.split(',');
        // console.log(durationArray.length);

        const newProject = new Project({
            pName,
            startDate: formattedStartDate,
            endDate: formattedEndDate,
            Skill: skills
        });
        await newProject.save();
        for (let i = 0; i < skills.length; i++) {
            const skill = skills[i];
            const duration = durations[i];
            console.log(skill);
            console.log(duration);

            const skillDocument = await Skill.findOne({ sName: skill }).select('eId');

            if (!skillDocument) {
                console.log(`No employees found with this skill: ${skill}`);
                continue;
            }
            console.log(skillDocument);
            const works = await Work.find({ eId: { $in: skillDocument.eId } })
                .sort({ endDate: 1 });
            console.log(works);
            const skillEIds = skillDocument.eId.map(eId => eId.toString());
            const missingEIds = skillEIds.filter(eId => !works.some(work => work.eId.toString() === eId));
            let selectedEId;

            if (missingEIds.length > 0) {
                console.log(`The following eIds are not present in Work for skill ${skill}:`, missingEIds);
                selectedEId = missingEIds[0];
            } else {
                selectedEId = works.find(work => {
                    const workEndDate = new Date(work.endDate);
                    return workEndDate < formattedStartDate || formattedStartDate.getTime() + duration * 24 * 60 * 60 * 1000 < work.startDate;
                })?.eId;
            }

            if (!selectedEId) {
                const employeeProjectsCounts = works.reduce((counts, work) => {
                    counts[work.eId] = (counts[work.eId] || 0) + 1;
                    return counts;
                }, {});

                const sortedEmployeeProjectsCounts = Object.entries(employeeProjectsCounts)
                    .sort((a, b) => a[1] - b[1]);

                selectedEId = sortedEmployeeProjectsCounts[0][0];

            }

            if (selectedEId) {
                const newWork = new Work({
                    pId: newProject._id,
                    eId: selectedEId,
                    techName: skill,
                    startDate: formattedStartDate,
                    endDate: new Date(formattedStartDate.getTime() + duration * 24 * 60 * 60 * 1000)
                });
                await newWork.save();
            } else {
                console.log(`No suitable employee found for skill ${skill}`);
            }
        }
        return res.status(200).json({ message: 'Project added successfully' });
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Internal server error' });
    }
}
export const getProjectsForEmp = async (req, res) => {
    const { eId, status } = req.query;
    try {
        let query = { eId };
        if (status && status !== 'ALL') {
            query.status = status;
        }
        console.log(query);
        const employeeProjects = await Work
            .find(query)
            .select('pId techName startDate endDate status')
            .populate({ path: 'pId', select: 'pName' });

        const projectsWithEIds = await Promise.all(
            employeeProjects.map(async (project) => {
                const eIds = await Work.find({ pId: project.pId, eId: { $ne: eId } })
                    .select('eId techName status')
                    .populate({ path: 'eId', select: 'eName email' });
                return { ...project.toObject(), coWorkers: eIds };
            })
        );

        res.status(200).json({ projects: projectsWithEIds });
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};
export const getProjectsForAdmin = async (req, res) => {
    try {
        const works = await Work.find().populate('pId').populate({
            path: 'eId',
            select: 'eName email status'
        }).sort({ _id: -1 });


        const projectsWithCoworkers = works.reduce((projects, work) => {
            const projectId = work.pId._id.toString();
            if (!projects[projectId]) {
                projects[projectId] = {
                    pId: work.pId,
                    coWorkers: []
                };
            }
            projects[projectId].coWorkers.push({
                eId: work.eId,
                status: work.status
            });
            return projects;
        }, {});

        const projectsArray = Object.values(projectsWithCoworkers);

        res.status(200).json({ projects: projectsArray });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};


export const changeStatus = async (req, res) => {
    const { eId, pId, status } = req.body;

    try {
        const workEntry = await Work.findOne({ eId, pId });

        if (!workEntry) {
            return res.status(404).json({ message: 'Work entry not found' });
        }

        workEntry.status = status;
        await workEntry.save();

        res.status(200).json({ message: 'Status updated successfully', workEntry });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

